import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/conversation_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/repository/user_repo.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({@required this.userRepo});

  UserInfoModel _userInfoModel;
  XFile _pickedFile;
  bool _isLoading = false;

  UserInfoModel get userInfoModel => _userInfoModel;
  XFile get pickedFile => _pickedFile;
  bool get isLoading => _isLoading;

  Future<ResponseModel> getUserInfo() async {
    _pickedFile = null;
    ResponseModel _responseModel;
    Response response = await userRepo.getUserInfo();
    if (response.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(response.body);
      _responseModel = ResponseModel(true, 'successful');
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
    return _responseModel;
  }

  /*Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, password, _pickedFile);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.body);
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print('${response.statusCode} ${response.statusText}');
    }
    update();
    return _responseModel;
  }*/

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, response.bodyString);
      _pickedFile = null;
      getUserInfo();
      print(response.bodyString);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print(response.statusText);
    }
    update();
    return _responseModel;
  }

  void updateUserWithNewData(User user) {
    _userInfoModel.userInfo = user;
  }

  Future<ResponseModel> changePassword(UserInfoModel updatedUserModel) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.changePassword(updatedUserModel);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body["message"];
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return _responseModel;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void initData() {
    _pickedFile = null;
  }

  Future removeUser() async {
    _isLoading = true;
    update();
    Response response = await userRepo.deleteUser();
    _isLoading = false;
    if (response.statusCode == 200) {
      showCustomSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.find<CartController>().clearCartList();
      Get.find<WishListController>().removeWishes();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));

    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

}