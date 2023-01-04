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
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class BestReviewedItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _productList = productController.reviewedProductList;

      return (_productList != null && _productList.length == 0) ? SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(
              title: 'best_reviewed_food'.tr,
              onTap: () => Get.toNamed(RouteHelper.getPopularFoodRoute(false)),
            ),
          ),

          SizedBox(
            height: 220,
            child: _productList != null ? ListView.builder(
              controller: ScrollController(),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: _productList.length > 10 ? 10 : _productList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
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
                      height: 220,
                      width: 180,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
                              image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${_productList[index].image}',
                              height: 125, width: 170, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTag(
                            discount: _productList[index].discount, discountType: _productList[index].discountType,
                            inLeft: false,
                          ),
                          productController.isAvailable(_productList[index]) ? SizedBox() : NotAvailableWidget(isRestaurant: true),
                          Positioned(
                            top: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              ),
                              child: Row(children: [
                                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(_productList[index].avgRating.toStringAsFixed(1), style: robotoRegular),
                              ]),
                            ),
                          ),
                        ]),

                        Expanded(
                          child: Stack(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Text(
                                  _productList[index].name ?? '', textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2),

                                Text(
                                  _productList[index].restaurantName ?? '', textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                  productController.getDiscount(_productList[index]) > 0  ? Flexible(child: Text(
                                    // PriceConverter.convertPrice(productController.getStartingPrice(_productList[index])),
                                   '0', style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).errorColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )) : SizedBox(),
                                  SizedBox(width: _productList[index].discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                                  Text(
                                    PriceConverter.convertPrice(
                                     0 /*productController.getStartingPrice(_productList[index])*/, discount: productController.getDiscount(_productList[index]),
                                      discountType: productController.getDiscountType(_productList[index]),
                                    ),
                                    style: robotoMedium,
                                  ),
                                ]),
                              ]),
                            ),
                            Positioned(bottom: 0, right: 0, child: Container(
                              height: 25, width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor
                              ),
                              child: Icon(Icons.add, size: 20, color: Colors.white),
                            )),
                          ]),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : BestReviewedItemShimmer(productController: productController),
          ),
        ],
      );
    });
  }
}

class BestReviewedItemShimmer extends StatelessWidget {
  final ProductController productController;
  BestReviewedItemShimmer({@required this.productController});

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
          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          child: Container(
            height: 220, width: 180,
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
              duration: Duration(seconds: 2),
              enabled: productController.reviewedProductList == null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                Stack(children: [
                  Container(
                    height: 125, width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                      color: Colors.grey[300],
                    ),
                  ),
                  Positioned(
                    top: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      ),
                      child: Row(children: [
                        Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text('0.0', style: robotoRegular),
                      ]),
                    ),
                  ),
                ]),

                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Container(height: 15, width: 100, color: Colors.grey[300]),
                        SizedBox(height: 2),

                        Container(height: 10, width: 70, color: Colors.grey[300]),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Container(height: 10, width: 40, color: Colors.grey[300]),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(height: 15, width: 40, color: Colors.grey[300]),
                        ]),
                      ]),
                    ),
                    Positioned(bottom: 0, right: 0, child: Container(
                      height: 25, width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor
                      ),
                      child: Icon(Icons.add, size: 20, color: Colors.white),
                    )),
                  ]),
                ),

              ]),
            ),
          ),
        );
      },
    );
  }
}