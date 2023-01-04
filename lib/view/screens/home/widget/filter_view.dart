import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';

class FilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurant) {
      return restaurant.restaurantModel != null ? PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(value: 'all', child: Text('all'.tr), textStyle: robotoMedium.copyWith(
              color: restaurant.restaurantType == 'all'
                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
            )),
            PopupMenuItem(value: 'take_away', child: Text('take_away'.tr), textStyle: robotoMedium.copyWith(
              color: restaurant.restaurantType == 'take_away'
                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
            )),
            PopupMenuItem(value: 'delivery', child: Text('delivery'.tr), textStyle: robotoMedium.copyWith(
              color: restaurant.restaurantType == 'delivery'
                  ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).disabledColor,
            )),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
          child: Icon(Icons.filter_list),
        ),
        onSelected: (value) => restaurant.setRestaurantType(value),
      ) : SizedBox();
    });
  }
}