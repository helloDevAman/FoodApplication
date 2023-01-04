import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/menu_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/screens/menu/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double _ratio = ResponsiveHelper.isDesktop(context) ? 1.1 : ResponsiveHelper.isTab(context) ? 1.1 : 1.2;

    final List<MenuModel> _menuList = [
      MenuModel(icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.location, title: 'my_address'.tr, route: RouteHelper.getAddressRoute()),
      MenuModel(icon: Images.language, title: 'language'.tr, route: RouteHelper.getLanguageRoute('menu')),
      MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute(fromCheckout: false)),
      MenuModel(icon: Images.support, title: 'help_support'.tr, route: RouteHelper.getSupportRoute()),
      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),
      MenuModel(icon: Images.about_us, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),
      MenuModel(icon: Images.terms, title: 'terms_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
      MenuModel(icon: Images.chat, title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
    ];

    if(Get.find<SplashController>().configModel.refundPolicyStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.refund, title: 'refund_policy'.tr, route: RouteHelper.getHtmlRoute('refund-policy')));
    }
    if(Get.find<SplashController>().configModel.cancellationPolicyStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.cancelation, title: 'cancellation_policy'.tr, route: RouteHelper.getHtmlRoute('cancellation-policy')));
    }
    if(Get.find<SplashController>().configModel.shippingPolicyStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.shipping_policy, title: 'shipping_policy'.tr, route: RouteHelper.getHtmlRoute('shipping-policy')));
    }
    if(Get.find<SplashController>().configModel.refEarningStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.refer_code, title: 'refer'.tr, route: RouteHelper.getReferAndEarnRoute()));
    }
    if(Get.find<SplashController>().configModel.customerWalletStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.wallet, title: 'wallet'.tr, route: RouteHelper.getWalletRoute(true)));
    }
    if(Get.find<SplashController>().configModel.loyaltyPointStatus == 1 ){
      _menuList.add(MenuModel(icon: Images.loyal, title: 'loyalty_points'.tr, route: RouteHelper.getWalletRoute(false)));
    }
    if(Get.find<SplashController>().configModel.toggleDmRegistration && !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.delivery_man_join, title: 'join_as_a_delivery_man'.tr,
        route: RouteHelper.getDeliverymanRegistrationRoute(),
      ));
    }
    if(Get.find<SplashController>().configModel.toggleRestaurantRegistration && !ResponsiveHelper.isDesktop(context)) {
      _menuList.add(MenuModel(
        icon: Images.restaurant_join, title: 'join_as_a_restaurant'.tr,
        route: RouteHelper.getRestaurantRegistrationRoute(),
      ));
    }
    _menuList.add(MenuModel(icon: Images.log_out, title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, route: ''));

    return PointerInterceptor(
      child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
              childAspectRatio: (1/_ratio),
              crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL, mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            itemCount: _menuList.length,
            itemBuilder: (context, index) {
              return MenuButton(menu: _menuList[index], isProfile: index == 0, isLogout: index == _menuList.length-1);
            },
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.PADDING_SIZE_SMALL : 0),

        ]),
      ),
    );
  }
}
