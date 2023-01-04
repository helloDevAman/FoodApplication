import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/discount_tag_without_image.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget({@required this.product, @required this.isRestaurant, @required this.restaurant, @required this.index,
   @required this.length, this.inRestaurant = false, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;
    String _image ;
    if(isRestaurant) {
      _image = restaurant.logo;
      _discount = restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null ? restaurant.discount.discountType : 'percent';
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      _isAvailable = restaurant.open == 1 && restaurant.active ;
    }else {
      _image = product.image;
      _discount = (product.restaurantDiscount == 0 || isCampaign) ? product.discount : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign) ? product.discountType : 'percent';
      _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);
    }



    return InkWell(
      onTap: () {
        if(isRestaurant) {
          if(restaurant != null){
            Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen(restaurant: restaurant));
          }
        }else {
          ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
            ProductBottomSheet(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign),
            backgroundColor: Colors.transparent, isScrollControlled: true,
          ) : Get.dialog(
            Dialog(child: ProductBottomSheet(product: product, inRestaurantPage: inRestaurant)),
          );
        }
      },
      child: Container(
        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [

              ((_image != null && _image.isNotEmpty) || isRestaurant) ? Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl
                        : _baseUrls.productImageUrl}'
                        '/${isRestaurant ? restaurant.logo : product.image}',
                    height: _desktop ? 120 : 65, width: _desktop ? 120 : 80, fit: BoxFit.cover,
                  ),
                ),
                DiscountTag(
                  discount: _discount, discountType: _discountType,
                  freeDelivery: isRestaurant ? restaurant.freeDelivery : false,
                ),
                _isAvailable ? SizedBox() : NotAvailableWidget(isRestaurant: isRestaurant),
              ]) : SizedBox.shrink(),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    isRestaurant ? restaurant.name : product.name,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: _desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isRestaurant ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                  Text(
                    isRestaurant ? restaurant.address ?? 'no_address_found'.tr : product.restaurantName ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: (_desktop || isRestaurant) ? 5 : 0),

                  !isRestaurant ? RatingBar(
                    rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: _desktop ? 15 : 12,
                    ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                  ) : SizedBox(),
                  SizedBox(height: (!isRestaurant && _desktop) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                  isRestaurant ? RatingBar(
                    rating: isRestaurant ? restaurant.avgRating : product.avgRating, size: _desktop ? 15 : 12,
                    ratingCount: isRestaurant ? restaurant.ratingCount : product.ratingCount,
                  ) : Row(children: [

                    Text(
                      PriceConverter.convertPrice(product.price, discount: _discount, discountType: _discountType),
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    SizedBox(width: _discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                    _discount > 0 ? Text(
                      PriceConverter.convertPrice(product.price),
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).disabledColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ) : SizedBox(),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    (_image != null && _image.isNotEmpty) ? SizedBox.shrink() : DiscountTagWithoutImage(discount: _discount, discountType: _discountType,
                        freeDelivery: isRestaurant ? restaurant.freeDelivery : false),

                  ]),

                ]),
              ),

              Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [

                !isRestaurant ? Padding(
                  padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                  child: Icon(Icons.add, size: _desktop ? 30 : 25),
                ) : SizedBox(),

                GetBuilder<WishListController>(builder: (wishController) {
                  bool _isWished = isRestaurant ? wishController.wishRestIdList.contains(restaurant.id)
                      : wishController.wishProductIdList.contains(product.id);
                  return InkWell(
                    onTap: () {
                      if(Get.find<AuthController>().isLoggedIn()) {
                        _isWished ? wishController.removeFromWishList(isRestaurant ? restaurant.id : product.id, isRestaurant)
                            : wishController.addToWishList(product, restaurant, isRestaurant);
                      }else {
                        showCustomSnackBar('you_are_not_logged_in'.tr);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                      child: Icon(
                        _isWished ? Icons.favorite : Icons.favorite_border,  size: _desktop ? 30 : 25,
                        color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                      ),
                    ),
                  );
                }),

              ]),

            ]),
          )),

          _desktop ? SizedBox() : Padding(
            padding: EdgeInsets.only(left: _desktop ? 130 : 90),
            child: Divider(color: index == length-1 ? Colors.transparent : Theme.of(context).disabledColor),
          ),

        ]),
      ),
    );
  }
}
