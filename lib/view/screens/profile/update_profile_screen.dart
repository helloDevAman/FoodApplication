import 'dart:io';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/userinfo_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    Get.find<UserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: GetBuilder<UserController>(builder: (userController) {
        if(userController.userInfoModel != null && _phoneController.text.isEmpty) {
          _firstNameController.text = userController.userInfoModel.fName ?? '';
          _lastNameController.text = userController.userInfoModel.lName ?? '';
          _phoneController.text = userController.userInfoModel.phone ?? '';
          _emailController.text = userController.userInfoModel.email ?? '';
        }

        return _isLoggedIn ? userController.userInfoModel != null ? ProfileBgWidget(
          backButton: true,
          circularImage: Center(child: Stack(children: [
            ClipOval(child: userController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
              userController.pickedFile.path, width: 100, height: 100, fit: BoxFit.cover,
            ) : Image.file(
              File(userController.pickedFile.path), width: 100, height: 100, fit: BoxFit.cover,
            ) : CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${userController.userInfoModel.image}',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
            Positioned(
              bottom: 0, right: 0, top: 0, left: 0,
              child: InkWell(
                onTap: () => userController.pickImage(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
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
          mainWidget: Column(children: [

            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(
                  'first_name'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                MyTextField(
                  hintText: 'first_name'.tr,
                  controller: _firstNameController,
                  focusNode: _firstNameFocus,
                  nextFocus: _lastNameFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text(
                  'last_name'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                MyTextField(
                  hintText: 'last_name'.tr,
                  controller: _lastNameController,
                  focusNode: _lastNameFocus,
                  nextFocus: _emailFocus,
                  inputType: TextInputType.name,
                  capitalization: TextCapitalization.words,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text(
                  'email'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                MyTextField(
                  hintText: 'email'.tr,
                  controller: _emailController,
                  focusNode: _emailFocus,
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Row(children: [
                  Text(
                    'phone'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).errorColor,
                  )),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                MyTextField(
                  hintText: 'phone'.tr,
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  inputType: TextInputType.phone,
                  isEnabled: false,
                ),

              ]))),
            ))),

            !userController.isLoading ? CustomButton(
              onPressed: () => _updateProfile(userController),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              buttonText: 'update'.tr,
            ) : Center(child: CircularProgressIndicator()),

          ]),
        ) : Center(child: CircularProgressIndicator()) : NotLoggedInScreen();
      }),
    );
  }

  void _updateProfile(UserController userController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    if (userController.userInfoModel.fName == _firstName &&
        userController.userInfoModel.lName == _lastName && userController.userInfoModel.phone == _phoneNumber &&
        userController.userInfoModel.email == _emailController.text && userController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (_phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (_phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel _updatedUser = UserInfoModel(fName: _firstName, lName: _lastName, email: _email, phone: _phoneNumber);
      ResponseModel _responseModel = await userController.updateUserInfo(_updatedUser, Get.find<AuthController>().getUserToken());
      if(_responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(_responseModel.message);
      }
    }
  }
}
