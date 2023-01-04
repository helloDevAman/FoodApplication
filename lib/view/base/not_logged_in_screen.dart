import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Image.asset(
            Images.guest,
            width: MediaQuery.of(context).size.height*0.25,
            height: MediaQuery.of(context).size.height*0.25,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01),

          Text(
            'sorry'.tr,
            style: robotoBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).primaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01),

          Text(
            'you_are_not_logged_in'.tr,
            style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.04),

          SizedBox(
            width: 200,
            child: CustomButton(buttonText: 'login_to_continue'.tr, height: 40, onPressed: () {
              Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
            }),
          ),

        ]),
      ),
    );
  }
}
