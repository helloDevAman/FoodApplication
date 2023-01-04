import 'dart:async';

import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/business_plan_body.dart';
import 'package:efood_multivendor/data/model/body/delivery_man_body.dart';
import 'package:efood_multivendor/data/model/body/restaurant_body.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.REGISTER_URI, signUpBody.toJson());
  }

  Future<Response> login({String phone, String password}) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, {"phone": phone, "password": password});
  }

  Future<Response> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(AppConstants.SOCIAL_LOGIN_URL, socialLogInBody.toJson());
  }

  Future<Response> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(AppConstants.SOCIAL_REGISTER_URL, socialLogInBody.toJson());
  }

  Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    }else {
      _deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '@';
    if(!GetPlatform.isWeb) {
      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
      }catch(e) {}
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  Future<Response> forgetPassword(String phone) async {
    return await apiClient.postData(AppConstants.FORGET_PASSWORD_URI, {"phone": phone});
  }

  Future<Response> verifyToken(String phone, String token) async {
    return await apiClient.postData(AppConstants.VERIFY_TOKEN_URI, {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String resetToken, String number, String password, String confirmPassword) async {
    return await apiClient.postData(
      AppConstants.RESET_PASSWORD_URI,
      {"_method": "put", "reset_token": resetToken, "phone": number, "password": password, "confirm_password": confirmPassword},
    );
  }

  Future<Response> checkEmail(String email) async {
    return await apiClient.postData(AppConstants.CHECK_EMAIL_URI, {"email": email});
  }

  Future<Response> verifyEmail(String email, String token) async {
    return await apiClient.postData(AppConstants.VERIFY_EMAIL_URI, {"email": email, "token": token});
  }

  Future<Response> updateZone() async {
    return await apiClient.getData(AppConstants.UPDATE_ZONE_URL);
  }

  Future<Response> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.VERIFY_PHONE_URI, {"phone": phone, "otp": otp});
  }

  // for  user token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, null, sharedPreferences.getString(AppConstants.LANGUAGE_CODE),null, null);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedData() {
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    apiClient.token = null;
    apiClient.updateHeader(null, null, null,null, null);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
        if(isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_LIST_URI);
  }

  Future<Response> registerRestaurant(RestaurantBody restaurant, XFile logo, XFile cover) async {
    return apiClient.postMultipartData(
      AppConstants.RESTAURANT_REGISTER_URI, restaurant.toJson(), [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }

  Future<Response> getPackageList() async {
    return await apiClient.getData(AppConstants.RESTAURANT_PACKAGES_URI);
  }

  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody) async {
    return await apiClient.postData(AppConstants.BUSINESS_PLAN_URI, businessPlanBody.toJson());
  }

  Future<Response> registerDeliveryMan(DeliveryManBody deliveryManBody, List<MultipartBody> multiParts) async {
    return apiClient.postMultipartData(AppConstants.DM_REGISTER_URI, deliveryManBody.toJson(), multiParts);
  }

}
