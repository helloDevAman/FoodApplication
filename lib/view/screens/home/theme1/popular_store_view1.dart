import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class PopularStoreView1 extends StatelessWidget {
  final bool isPopular;
  PopularStoreView1({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      List<Restaurant> _restaurant = isPopular ? restaurantController.popularRestaurantList : restaurantController.latestRestaurantList;

      return (_restaurant != null && _restaurant.length == 0) ? SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, isPopular ? 15 : 15, 10, 10),
            child: TitleWidget(
              title: isPopular ? 'popular_restaurants'.tr : '${'new_on'.tr} ${AppConstants.APP_NAME}',
              onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isPopular ? 'popular' : 'latest')),
            ),
          ),

          SizedBox(
            height: 150,
            child: _restaurant != null ? ListView.builder(
              controller: ScrollController(),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: _restaurant.length > 10 ? 10 : _restaurant.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getRestaurantRoute(_restaurant[index].id),
                        arguments: RestaurantScreen(restaurant: _restaurant[index]),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(
                          color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300],
                          blurRadius: 5, spreadRadius: 1,
                        )],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}'
                                  '/${_restaurant[index].coverPhoto}',
                              height: 90, width: 200, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTag(
                            discount: restaurantController.getDiscount(_restaurant[index]),
                            discountType: restaurantController.getDiscountType(_restaurant[index]),
                            freeDelivery: _restaurant[index].freeDelivery,
                          ),
                          restaurantController.isOpenNow(_restaurant[index]) ? SizedBox() : NotAvailableWidget(isRestaurant: true),
                          Positioned(
                            top: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            child: GetBuilder<WishListController>(builder: (wishController) {
                              bool _isWished = wishController.wishRestIdList.contains(_restaurant[index].id);
                              return InkWell(
                                onTap: () {
                                  if(Get.find<AuthController>().isLoggedIn()) {
                                    _isWished ? wishController.removeFromWishList(_restaurant[index].id, true)
                                        : wishController.addToWishList(null, _restaurant[index], true);
                                  }else {
                                    showCustomSnackBar('you_are_not_logged_in'.tr);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Icon(
                                    _isWished ? Icons.favorite : Icons.favorite_border,  size: 15,
                                    color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ]),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                _restaurant[index].name ?? '',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                _restaurant[index].address ?? '',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),

                              RatingBar(
                                rating: _restaurant[index].avgRating,
                                ratingCount: _restaurant[index].ratingCount,
                                size: 12,
                              ),
                            ]),
                          ),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : PopularStoreShimmer(restaurantController: restaurantController),
          ),
        ],
      );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final RestaurantController restaurantController;
  PopularStoreShimmer({@required this.restaurantController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index){
        return Container(
          height: 150,
          width: 200,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 10, width: 100, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[300]),
                    SizedBox(height: 5),

                    RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                  ]),
                ),
              ),

            ]),
          ),
        );
      },
    );
  }
}

