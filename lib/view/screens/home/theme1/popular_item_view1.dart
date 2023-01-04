import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class PopularItemView1 extends StatelessWidget {
  final bool isPopular;
  PopularItemView1({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _productList = isPopular ? productController.popularProductList : productController.reviewedProductList;

      return (_productList != null && _productList.length == 0) ? SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(
              title: isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr,
              onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(isPopular)),
            ),
          ),

          SizedBox(
            height: 90,
            child: _productList != null ? ListView.builder(
              controller: ScrollController(),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: _productList.length > 10 ? 10 : _productList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.fromLTRB(2, 2, Dimensions.PADDING_SIZE_SMALL, 2),
                  child: InkWell(
                    onTap: () {
                      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                        ProductBottomSheet(product: _productList[index], isCampaign: false),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      ) : Get.dialog(
                        Dialog(child: ProductBottomSheet(product: _productList[index])),
                      );
                    },
                    child: Container(
                      height: 90, width: 250,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(
                          color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300],
                          blurRadius: 5, spreadRadius: 1,
                        )],
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                  '/${_productList[index].image}',
                              height: 80, width: 80, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTag(
                            discount: productController.getDiscount(_productList[index]),
                            discountType: productController.getDiscountType(_productList[index]),
                          ),
                          productController.isAvailable(_productList[index]) ? SizedBox() : NotAvailableWidget(),
                        ]),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                _productList[index].name,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              Text(
                                _productList[index].restaurantName,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),

                              RatingBar(
                                rating: _productList[index].avgRating, size: 12,
                                ratingCount: _productList[index].ratingCount,
                              ),

                              Row(children: [
                                Expanded(
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    _productList[index].discount > 0 ? Flexible(child: Text(
                                      PriceConverter.convertPrice(_productList[index].price),
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).errorColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    )) : SizedBox(),
                                    SizedBox(width: _productList[index].discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                                    Text(
                                      PriceConverter.convertPrice(
                                        _productList[index].price, discount: _productList[index].discount,
                                        discountType: _productList[index].discountType,
                                      ),
                                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                                ),
                                Container(
                                  height: 25, width: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor
                                  ),
                                  child: Icon(Icons.add, size: 20, color: Colors.white),
                                ),
                              ]),
                            ]),
                          ),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : PopularItemShimmer(enabled: _productList == null),
          ),
        ],
      );
    });
  }
}

class PopularItemShimmer extends StatelessWidget {
  final bool enabled;
  PopularItemShimmer({@required this.enabled});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.fromLTRB(2, 2, Dimensions.PADDING_SIZE_SMALL, 2),
          child: Container(
            height: 90, width: 250,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            child: Shimmer(
              duration: Duration(seconds: 1),
              interval: Duration(seconds: 1),
              enabled: enabled,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.grey[300],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 15, width: 100, color: Colors.grey[300]),
                      SizedBox(height: 5),

                      Container(height: 10, width: 130, color: Colors.grey[300]),
                      SizedBox(height: 5),

                      RatingBar(rating: 0, size: 12, ratingCount: 0),

                      Row(children: [
                        Expanded(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Container(height: 10, width: 40, color: Colors.grey[300]),
                            Container(height: 15, width: 40, color: Colors.grey[300]),
                          ]),
                        ),
                        Container(
                          height: 25, width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor
                          ),
                          child: Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ]),
                    ]),
                  ),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}

