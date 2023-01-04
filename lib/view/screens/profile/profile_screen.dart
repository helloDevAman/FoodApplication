import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
     _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _showWalletCard = Get.find<SplashController>().configModel.customerWalletStatus == 1
        || Get.find<SplashController>().configModel.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: true,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                  '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
          ),
          mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: Center(child: Container(
            width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(children: [

              Text(
                _isLoggedIn ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}' : 'guest'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              SizedBox(height: 30),

              _isLoggedIn ? Column(children: [
                Row(children: [
                  ProfileCard(title: 'since_joining'.tr, data: '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  ProfileCard(title: 'total_order'.tr, data: userController.userInfoModel.orderCount.toString()),
                ]),
                SizedBox(height: _showWalletCard ? Dimensions.PADDING_SIZE_SMALL : 0),
                _showWalletCard ? Row(children: [
                  Get.find<SplashController>().configModel.customerWalletStatus == 1 ? ProfileCard(
                    title: 'wallet_amount'.tr,
                    data: PriceConverter.convertPrice(userController.userInfoModel.walletBalance),
                  ) : SizedBox.shrink(),
                  SizedBox(width: Get.find<SplashController>().configModel.customerWalletStatus == 1
                      && Get.find<SplashController>().configModel.loyaltyPointStatus == 1 ? Dimensions.PADDING_SIZE_SMALL : 0.0),
                  Get.find<SplashController>().configModel.loyaltyPointStatus == 1 ? ProfileCard(
                    title: 'loyalty_points'.tr,
                    data: userController.userInfoModel.loyaltyPoint != null ? userController.userInfoModel.loyaltyPoint.toString() : '0',
                  ) : SizedBox.shrink(),
                ]) : SizedBox(),
              ]) : SizedBox(),
              SizedBox(height: _isLoggedIn ? 30 : 0),

              ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              _isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                return ProfileButton(
                  icon: Icons.notifications, title: 'notification'.tr,
                  isButtonActive: authController.notification, onTap: () {
                  authController.setNotificationActive(!authController.notification);
                },
                );
              }) : SizedBox(),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),

              _isLoggedIn ? userController.userInfoModel.socialId == null ? ProfileButton(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }) : SizedBox() : SizedBox(),
              SizedBox(height: _isLoggedIn ? userController.userInfoModel.socialId == null ? Dimensions.PADDING_SIZE_SMALL : 0 : 0),

              ProfileButton(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : Dimensions.PADDING_SIZE_LARGE),

              _isLoggedIn ? ProfileButton(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(ConfirmationDialog(icon: Images.support,
                    title: 'are_you_sure_to_delete_account'.tr,
                    description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                    onYesPressed: () => userController.removeUser(),
                  ), useSafeArea: false);
                },
              ) : SizedBox(),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}
