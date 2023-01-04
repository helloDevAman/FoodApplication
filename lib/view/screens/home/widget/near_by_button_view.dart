import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NearByButtonView extends StatelessWidget {
  const NearByButtonView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.WEB_MAX_WIDTH,
      height: 90,
      margin: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL, top: Dimensions.PADDING_SIZE_DEFAULT),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        boxShadow: [BoxShadow(
          color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
          blurRadius: 5, spreadRadius: 1,
        )],
      ),
      child: Row(children: [

        Image.asset(Images.near_restaurant, height: 40, width: 40, fit: BoxFit.cover),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

        Expanded(
          child: Text(
            'find_nearby_restaurant_near_you'.tr, textAlign: TextAlign.start,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),

        CustomButton(buttonText: 'see_location'.tr, width: 120, height: 40, onPressed: ()=> Get.toNamed(RouteHelper.getMapViewRoute())),

      ]),
    );
  }
}
