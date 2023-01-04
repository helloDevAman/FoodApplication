import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool showCart;
  CustomAppBar({@required this.title, this.isBackButtonExist = true, this.onBackPressed, this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop ? WebMenuBar() : AppBar(
      title: Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      actions: showCart ? [
        IconButton(onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        icon: CartWidget(color: Theme.of(context).textTheme.bodyText1.color, size: 25),
      )] : null,
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, GetPlatform.isDesktop ? 70 : 50);
}
