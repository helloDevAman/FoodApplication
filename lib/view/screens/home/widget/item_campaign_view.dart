import 'package:efood_multivendor/controller/campaign_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
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

class ItemCampaignView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetBuilder<CampaignController>(builder: (campaignController) {
      return (campaignController.itemCampaignList != null && campaignController.itemCampaignList.length == 0) ? SizedBox() : Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: TitleWidget(title: 'campaigns'.tr, onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute())),
          ),

          SizedBox(
            height: 150,
            child: campaignController.itemCampaignList != null ? ListView.builder(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
              itemCount: campaignController.itemCampaignList.length > 10 ? 10 : campaignController.itemCampaignList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                  child: InkWell(
                    onTap: () {
                      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                        ProductBottomSheet(product: campaignController.itemCampaignList[index], isCampaign: true),
                        backgroundColor: Colors.transparent, isScrollControlled: true,
                      ) : Get.dialog(
                        Dialog(child: ProductBottomSheet(product: campaignController.itemCampaignList[index], isCampaign: true)),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 130,
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
                              image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                                  '/${campaignController.itemCampaignList[index].image}',
                              height: 90, width: 130, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTag(
                            discount: campaignController.itemCampaignList[index].restaurantDiscount > 0
                                ? campaignController.itemCampaignList[index].restaurantDiscount
                                : campaignController.itemCampaignList[index].discount,
                            discountType: campaignController.itemCampaignList[index].restaurantDiscount > 0 ? 'percent'
                                : campaignController.itemCampaignList[index].discountType,
                          ),
                          Get.find<ProductController>().isAvailable(campaignController.itemCampaignList[index])
                              ? SizedBox() : NotAvailableWidget(),
                        ]),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                campaignController.itemCampaignList[index].name,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),

                              Text(
                                campaignController.itemCampaignList[index].restaurantName,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      PriceConverter.convertPrice(campaignController.itemCampaignList[index].price),
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ),
                                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                                  Text(
                                    campaignController.itemCampaignList[index].avgRating.toStringAsFixed(1),
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),

                      ]),
                    ),
                  ),
                );
              },
            ) : ItemCampaignShimmer(campaignController: campaignController),
          ),
        ],
      );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  ItemCampaignShimmer({@required this.campaignController});

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
          width: 130,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300], blurRadius: 10, spreadRadius: 1)]
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: campaignController.itemCampaignList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Container(
                height: 90, width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(height: 10, width: 100, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    SizedBox(height: 5),

                    Container(height: 10, width: 130, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                    SizedBox(height: 5),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Container(height: 10, width: 30, color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
                      RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                    ]),
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

