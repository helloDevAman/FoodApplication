import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_shimmer.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:efood_multivendor/view/screens/home/theme1/restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;
  final bool showTheme1Restaurant;
  ProductView({@required this.restaurants, @required this.products, @required this.isRestaurant, this.isScrollable = false,
    this.shimmerLength = 20, this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), this.noDataText,
    this.isCampaign = false, this.inRestaurantPage = false, this.type, this.onVegFilterTap, this.showTheme1Restaurant = false});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if(isRestaurant) {
      _isNull = restaurants == null;
      if(!_isNull) {
        _length = restaurants.length;
      }
    }else {
      _isNull = products == null;
      if(!_isNull) {
        _length = products.length;
      }
    }

    return Column(children: [

      type != null ? VegFilterWidget(type: type, onSelected: onVegFilterTap) : SizedBox(),

      !_isNull ? _length > 0 ? GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
          childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : showTheme1Restaurant ? 1.9 : 4,
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
        ),
        physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: _length,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantWidget(restaurant: restaurants[index], index: index, inStore: inRestaurantPage) :  ProductWidget(
            isRestaurant: isRestaurant, product: isRestaurant ? null : products[index],
            restaurant: isRestaurant ? restaurants[index] : null, index: index, length: _length, isCampaign: isCampaign,
            inRestaurant: inRestaurantPage,
          );
        },
      ) : NoDataScreen(
        text: noDataText != null ? noDataText : isRestaurant ? 'no_restaurant_available'.tr : 'no_food_available'.tr,
      ) : GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
          childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : showTheme1Restaurant ? 1.9 : 4,
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
        ),
        physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        shrinkWrap: isScrollable ? false : true,
        itemCount: shimmerLength,
        padding: padding,
        itemBuilder: (context, index) {
          return showTheme1Restaurant ? RestaurantShimmer(isEnable: _isNull) : ProductShimmer(isEnabled: _isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength-1);
        },
      ),

    ]);
  }
}
