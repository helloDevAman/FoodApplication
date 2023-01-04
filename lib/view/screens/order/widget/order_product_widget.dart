import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProductWidget extends StatelessWidget {
  final OrderModel order;
  final OrderDetailsModel orderDetails;
  OrderProductWidget({@required this.order, @required this.orderDetails});
  
  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    orderDetails.addOns.forEach((addOn) {
      _addOnText = _addOnText + '${(_addOnText.isEmpty) ? '' : ',  '}${addOn.name} (${addOn.quantity})';
    });

    String _variationText = '';
    if(orderDetails.variation.length > 0) {
      for(Variation variation in orderDetails.variation) {
        _variationText += '${_variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
        for(VariationValue value in variation.variationValues) {
          _variationText += '${_variationText.endsWith('(') ? '' : ', '}${value.level}';
        }
        _variationText += ')';
      }
    }else if(orderDetails.oldVariation.length > 0) {
      List<String> _variationTypes = orderDetails.oldVariation[0].type.split('-');
      if(_variationTypes.length == orderDetails.foodDetails.choiceOptions.length) {
        int _index = 0;
        orderDetails.foodDetails.choiceOptions.forEach((choice) {
          _variationText = _variationText + '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      }else {
        _variationText = orderDetails.oldVariation[0].type;
      }
    }
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        orderDetails.foodDetails.image != null && orderDetails.foodDetails.image.isNotEmpty ?
        Padding(
          padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            child: CustomImage(
              height: 50, width: 50, fit: BoxFit.cover,
              image: '${orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl
                  : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/'
                  '${orderDetails.foodDetails.image}',
            ),
          ),
        ) : SizedBox.shrink(),

        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(
                orderDetails.foodDetails.name,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),
              Text('${'quantity'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              Text(
                orderDetails.quantity.toString(),
                style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ]),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Row(children: [
              Expanded(child: Text(
                PriceConverter.convertPrice(orderDetails.price),
                style: robotoMedium,
              )),
              Get.find<SplashController>().configModel.toggleVegNonVeg ? Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Text(
                  orderDetails.foodDetails.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                ),
              ) : SizedBox(),
            ]),

          ]),
        ),
      ]),

      _addOnText.isNotEmpty ? Padding(
        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Row(children: [
          SizedBox(width: 60),
          Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
          Flexible(child: Text(
              _addOnText,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
          ))),
        ]),
      ) : SizedBox(),

      _variationText != '' ? (orderDetails.foodDetails.variations != null && orderDetails.foodDetails.variations.length > 0) ? Padding(
        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Row(children: [
          SizedBox(width: 60),
          Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
          Flexible(child: Text(
              _variationText,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
          ))),
        ]),
      ) : SizedBox() : SizedBox(),

      Divider(height: Dimensions.PADDING_SIZE_LARGE),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
    ]);
  }
}
