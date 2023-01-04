import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VegFilterWidget extends StatelessWidget {
  final String type;
  final Function(String value) onSelected;
  VegFilterWidget({@required this.type, @required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final bool _ltr = Get.find<LocalizationController>().isLtr;

    return Get.find<SplashController>().configModel.toggleVegNonVeg ? Align(alignment: Alignment.center, child: Container(
      height: 30,
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Get.find<ProductController>().productTypeList.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onSelected(Get.find<ProductController>().productTypeList[index]),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(
                    _ltr ? index == 0 ? Dimensions.RADIUS_SMALL : 0
                        : index == Get.find<ProductController>().productTypeList.length-1
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                  right: Radius.circular(
                    _ltr ? index == Get.find<ProductController>().productTypeList.length-1
                        ? Dimensions.RADIUS_SMALL : 0 : index == 0
                        ? Dimensions.RADIUS_SMALL : 0,
                  ),
                ),
                color: Get.find<ProductController>().productTypeList[index] == type ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
              ),
              child: Text(
                Get.find<ProductController>().productTypeList[index].tr,
                style: Get.find<ProductController>().productTypeList[index] == type
                    ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor)
                    : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
          );
        },
      ),
    )) : SizedBox();
  }
}
