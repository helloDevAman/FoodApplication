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

class WebPopularRestaurantView extends StatelessWidget {
  final bool isPopular;
  WebPopularRestaurantView({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      List<Restaurant> _restaurantList = isPopular ? restController.popularRestaurantList : restController.latestRestaurantList;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(title: isPopular ? 'popular_restaurants'.tr : '${'new_on'.tr} ${AppConstants.APP_NAME}'),
          ),

          _restaurantList != null ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: (1/0.7),
              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            itemCount: _restaurantList.length > 5 ? 6 : _restaurantList.length,
            itemBuilder: (context, index){
              if(index == 5) {
                return InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(isPopular ? 'popular' : 'latest')),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(
                        color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                        blurRadius: 5, spreadRadius: 1,
                      )],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+${_restaurantList.length-5}\n${'more'.tr}', textAlign: TextAlign.center,
                      style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () {
                  Get.toNamed(
                    RouteHelper.getRestaurantRoute(_restaurantList[index].id),
                    arguments: RestaurantScreen(restaurant: _restaurantList[index]),
                  );
                },
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(
                      color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                      blurRadius: 5, spreadRadius: 1,
                    )],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}'
                              '/${_restaurantList[index].coverPhoto}',
                          height: 120, width: 300, fit: BoxFit.cover,
                        ),
                      ),
                      DiscountTag(
                        discount: _restaurantList[index].discount != null
                            ? _restaurantList[index].discount.discount : 0,
                        discountType: 'percent', freeDelivery: _restaurantList[index].freeDelivery,
                      ),
                      restController.isOpenNow(_restaurantList[index]) ? SizedBox() : NotAvailableWidget(isRestaurant: true),
                      Positioned(
                        top: Dimensions.PADDING_SIZE_EXTRA_SMALL, right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        child: GetBuilder<WishListController>(builder: (wishController) {
                          bool _isWished = wishController.wishRestIdList.contains(_restaurantList[index].id);
                          return InkWell(
                            onTap: () {
                              if(Get.find<AuthController>().isLoggedIn()) {
                                _isWished ? wishController.removeFromWishList(_restaurantList[index].id, true)
                                    : wishController.addToWishList(null, _restaurantList[index], true);
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
                                _isWished ? Icons.favorite : Icons.favorite_border,  size: 20,
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
                            _restaurantList[index].name,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          Text(
                            _restaurantList[index].address,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          RatingBar(
                            rating: _restaurantList[index].avgRating,
                            ratingCount: _restaurantList[index].ratingCount,
                            size: 15,
                          ),
                        ]),
                      ),
                    ),

                  ]),
                ),
              );
            },
          ) : PopularRestaurantShimmer(restController: restController),
        ],
      );
    });
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  final RestaurantController restController;
  PopularRestaurantShimmer({@required this.restController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: (1/0.7),
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE, mainAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      itemCount: 6,
      itemBuilder: (context, index){
        return Container(
          width: 300,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 120, width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 15, width: 100, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
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

