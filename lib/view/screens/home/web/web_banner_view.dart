import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebBannerView extends StatelessWidget {
  final BannerController bannerController;
  WebBannerView({@required this.bannerController});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    return Container(
      color: Color(0xFF171A29),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      alignment: Alignment.center,
      child: SizedBox(width: 1210, height: 220, child: bannerController.bannerImageList != null ? Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: PageView.builder(
              controller: _pageController,
              itemCount: (bannerController.bannerImageList.length/2).ceil(),
              itemBuilder: (context, index) {
                int index1 = index * 2;
                int index2 = (index * 2) + 1;
                bool _hasSecond = index2 < bannerController.bannerImageList.length;
                String _baseUrl1 = bannerController.bannerDataList[index1] is BasicCampaignModel ? Get.find<SplashController>()
                    .configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.bannerImageUrl;
                String _baseUrl2 = _hasSecond ? bannerController.bannerDataList[index2] is BasicCampaignModel ? Get.find<SplashController>()
                    .configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.bannerImageUrl : '';
                return Row(children: [

                  Expanded(child: InkWell(
                    onTap: () => _onTap(index1, context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '$_baseUrl1/${bannerController.bannerImageList[index1]}', fit: BoxFit.cover, height: 220,
                      ),
                    ),
                  )),

                  SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                  Expanded(child: _hasSecond ? InkWell(
                    onTap: () => _onTap(index2, context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        image: '$_baseUrl2/${bannerController.bannerImageList[index2]}', fit: BoxFit.cover, height: 220,
                      ),
                    ),
                  ) : SizedBox()),

                ]);
              },
              onPageChanged: (int index) => bannerController.setCurrentIndex(index, true),
            ),
          ),

          bannerController.currentIndex != 0 ? Positioned(
            top: 0, bottom: 0, left: 0,
            child: InkWell(
              onTap: () => _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor,
                ),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ) : SizedBox(),

          bannerController.currentIndex != ((bannerController.bannerImageList.length/2).ceil()-1) ? Positioned(
            top: 0, bottom: 0, right: 0,
            child: InkWell(
              onTap: () => _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor,
                ),
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ) : SizedBox(),

        ],
      ) : WebBannerShimmer(bannerController: bannerController)),
    );
  }

  void _onTap(int index, BuildContext context) {
    if(bannerController.bannerDataList[index] is Product) {
      Product _product = bannerController.bannerDataList[index];
      ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (con) => ProductBottomSheet(product: _product),
      ) : showDialog(context: context, builder: (con) => Dialog(
          child: ProductBottomSheet(product: _product)),
      );
    }else if(bannerController.bannerDataList[index] is Restaurant) {
      Restaurant _restaurant = bannerController.bannerDataList[index];
      Get.toNamed(
        RouteHelper.getRestaurantRoute(_restaurant.id),
        arguments: RestaurantScreen(restaurant: _restaurant),
      );
    }else if(bannerController.bannerDataList[index] is BasicCampaignModel) {
      BasicCampaignModel _campaign = bannerController.bannerDataList[index];
      Get.toNamed(RouteHelper.getBasicCampaignRoute(_campaign));
    }
  }
}

class WebBannerShimmer extends StatelessWidget {
  final BannerController bannerController;
  WebBannerShimmer({@required this.bannerController});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 2),
      enabled: bannerController.bannerImageList == null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
        child: Row(children: [

          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
          )),

          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
          )),

        ]),
      ),
    );
  }
}

