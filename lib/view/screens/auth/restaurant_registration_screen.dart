import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/data/model/body/restaurant_body.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:efood_multivendor/view/screens/auth/widget/registration_stepper_widget.dart';
import 'package:efood_multivendor/view/screens/auth/widget/select_location_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantRegistrationScreen extends StatefulWidget {
  const RestaurantRegistrationScreen({Key key}) : super(key: key);

  @override
  State<RestaurantRegistrationScreen> createState() => _RestaurantRegistrationScreenState();
}

class _RestaurantRegistrationScreenState extends State<RestaurantRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _vatFocus = FocusNode();
  final FocusNode _minTimeFocus = FocusNode();
  final FocusNode _maxTimeFocus = FocusNode();
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _canBack = false;

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getZoneList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
        return WillPopScope(
          onWillPop: () async{
            if(_canBack) {
              return true;
            }else {
              authController.showBackPressedDialogue('your_registration_not_setup_yet'.tr);
              return false;
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(title: 'restaurant_registration'.tr, onBackPressed: () =>  authController.showBackPressedDialogue('your_registration_not_setup_yet'.tr)),
            body: Center(child: SizedBox(width: context.width > 700 ? 700 : context.width, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
              RegistrationStepperWidget(status: '0'),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(children: [

                    CustomTextField(
                      hintText: 'restaurant_name'.tr,
                      controller: _nameController,
                      focusNode: _nameFocus,
                      nextFocus: _addressFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                      showTitle: true,
                    ),


                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    CustomTextField(
                      hintText: 'restaurant_address'.tr,
                      controller: _addressController,
                      focusNode: _addressFocus,
                      nextFocus: _vatFocus,
                      inputType: TextInputType.text,
                      capitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      showTitle: true,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    CustomTextField(
                      hintText: 'vat_tax'.tr,
                      controller: _vatController,
                      focusNode: _vatFocus,
                      nextFocus: _minTimeFocus,
                      inputType: TextInputType.number,
                      isAmount: true,
                      showTitle: true,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'minimum_delivery_time'.tr,
                        controller: _minTimeController,
                        focusNode: _minTimeFocus,
                        nextFocus: _maxTimeFocus,
                        inputType: TextInputType.number,
                        isNumber: true,
                        showTitle: true,
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(child: CustomTextField(
                        hintText: 'maximum_delivery_time'.tr,
                        controller: _maxTimeController,
                        focusNode: _maxTimeFocus,
                        inputType: TextInputType.number,
                        isNumber: true,
                        inputAction: TextInputAction.done,
                        showTitle: true,
                      )),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(
                      'logo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: authController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                          authController.pickedLogo.path, width: 150, height: 120, fit: BoxFit.cover,
                        ) : Image.file(
                          File(authController.pickedLogo.path), width: 150, height: 120, fit: BoxFit.cover,
                        ) : Image.asset(
                          Images.placeholder, width: 150, height: 120, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => authController.pickImage(true, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Text(
                      'cover_photo'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                          authController.pickedCover.path, width: context.width, height: 170, fit: BoxFit.cover,
                        ) : Image.file(
                          File(authController.pickedCover.path), width: context.width, height: 170, fit: BoxFit.cover,
                        ) : Image.asset(
                          Images.placeholder, width: context.width, height: 170, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => authController.pickImage(false, false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3, color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    authController.zoneList != null ? SelectLocationView(fromView: true) : Center(child: CircularProgressIndicator()),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Center(child: Text(
                      'owner_information'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    )),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'first_name'.tr,
                        controller: _fNameController,
                        focusNode: _fNameFocus,
                        nextFocus: _lNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(child: CustomTextField(
                        hintText: 'last_name'.tr,
                        controller: _lNameController,
                        focusNode: _lNameFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        showTitle: true,
                      )),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    CustomTextField(
                      hintText: 'phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.phone,
                      showTitle: true,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    Center(child: Text(
                      'login_information'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    )),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    CustomTextField(
                      hintText: 'email'.tr,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _passwordFocus,
                      inputType: TextInputType.emailAddress,
                      showTitle: true,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(children: [
                      Expanded(child: CustomTextField(
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        showTitle: true,
                      )),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(child: CustomTextField(
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        showTitle: true,
                      )),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    !authController.isLoading ? CustomButton(
                      buttonText: 'submit'.tr,
                      onPressed: () {
                        String _name = _nameController.text.trim();
                        String _address = _addressController.text.trim();
                        String _vat = _vatController.text.trim();
                        String _minTime = _minTimeController.text.trim();
                        String _maxTime = _maxTimeController.text.trim();
                        String _fName = _fNameController.text.trim();
                        String _lName = _lNameController.text.trim();
                        String _phone = _phoneController.text.trim();
                        String _email = _emailController.text.trim();
                        String _password = _passwordController.text.trim();
                        String _confirmPassword = _confirmPasswordController.text.trim();
                        if(_name.isEmpty) {
                          showCustomSnackBar('enter_restaurant_name'.tr);
                        }else if(_address.isEmpty) {
                          showCustomSnackBar('enter_restaurant_address'.tr);
                        }else if(_vat.isEmpty) {
                          showCustomSnackBar('enter_vat_amount'.tr);
                        }else if(_minTime.isEmpty) {
                          showCustomSnackBar('enter_minimum_delivery_time'.tr);
                        }else if(_maxTime.isEmpty) {
                          showCustomSnackBar('enter_maximum_delivery_time'.tr);
                        }else if(double.parse(_minTime) > double.parse(_maxTime)) {
                          showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                        }else if(authController.pickedLogo == null) {
                          showCustomSnackBar('select_restaurant_logo'.tr);
                        }else if(authController.pickedCover == null) {
                          showCustomSnackBar('select_restaurant_cover_photo'.tr);
                        }else if(authController.restaurantLocation == null) {
                          showCustomSnackBar('set_restaurant_location'.tr);
                        }else if(_fName.isEmpty) {
                          showCustomSnackBar('enter_your_first_name'.tr);
                        }else if(_lName.isEmpty) {
                          showCustomSnackBar('enter_your_last_name'.tr);
                        }else if(_phone.isEmpty) {
                          showCustomSnackBar('enter_phone_number'.tr);
                        }else if(_email.isEmpty) {
                          showCustomSnackBar('enter_email_address'.tr);
                        }else if(!GetUtils.isEmail(_email)) {
                          showCustomSnackBar('enter_a_valid_email_address'.tr);
                        }else if(_password.isEmpty) {
                          showCustomSnackBar('enter_password'.tr);
                        }else if(_password.length < 6) {
                          showCustomSnackBar('password_should_be'.tr);
                        }else if(_password != _confirmPassword) {
                          showCustomSnackBar('confirm_password_does_not_matched'.tr);
                        }else {
                          authController.registerRestaurant(RestaurantBody(
                            restaurantName: _name, restaurantAddress: _address, vat: _vat, minDeliveryTime: _minTime,
                            maxDeliveryTime: _maxTime, lat: authController.restaurantLocation.latitude.toString(), email: _email,
                            lng: authController.restaurantLocation.longitude.toString(), fName: _fName, lName: _lName, phone: _phone,
                            password: _password, zoneId: authController.zoneList[authController.selectedZoneIndex].id.toString(),
                          ));
                        }
                      },
                    ) : Center(child: CircularProgressIndicator()),
                  ]),
                ),
              ),

            ]),
            )),
          ),
        );
      }
    );
  }

}
