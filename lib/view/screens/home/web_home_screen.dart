import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/paginated_list_view.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_banner_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_food_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_category_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_campaign_view.dart';
import 'package:efood_multivendor/view/screens/home/web/web_popular_restaurant_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  WebHomeScreen({@required this.scrollController});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  ConfigModel _configModel;

  @override
  void initState() {
    super.initState();
    Get.find<BannerController>().setCurrentIndex(0, false);
    _configModel = Get.find<SplashController>().configModel;
  }

  @override
  Widget build(BuildContext context) {


    return CustomScrollView(
      controller: widget.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [

        SliverToBoxAdapter(child: GetBuilder<BannerController>(builder: (bannerController) {
          return bannerController.bannerImageList == null ? WebBannerView(bannerController: bannerController)
              : bannerController.bannerImageList.length == 0 ? SizedBox() : WebBannerView(bannerController: bannerController);
        })),


        SliverToBoxAdapter(
          child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            WebCategoryView(),
            SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                _configModel.popularRestaurant == 1 ? WebPopularRestaurantView(isPopular: true) : SizedBox(),

                WebCampaignView(),

                _configModel.popularFood == 1 ? WebPopularFoodView(isPopular: true) : SizedBox(),

                _configModel.newRestaurant == 1 ? WebPopularRestaurantView(isPopular: false) : SizedBox(),

                _configModel.mostReviewedFoods == 1 ? WebPopularFoodView(isPopular: false) : SizedBox(),

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 5),
                  child: Row(children: [
                    Expanded(child: Text(
                      'all_restaurants'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    )),
                    FilterView(),
                  ]),
                ),

                GetBuilder<RestaurantController>(builder: (restaurantController) {
                  return PaginatedListView(
                    scrollController: widget.scrollController,
                    totalSize: restaurantController.restaurantModel != null ? restaurantController.restaurantModel.totalSize : null,
                    offset: restaurantController.restaurantModel != null ? restaurantController.restaurantModel.offset : null,
                    onPaginate: (int offset) async => await restaurantController.getRestaurantList(offset, false),
                    productView: ProductView(
                      isRestaurant: true, products: null,
                      restaurants: restaurantController.restaurantModel != null ? restaurantController.restaurantModel.restaurants : null,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_SMALL,
                        vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0,
                      ),
                    ),
                  );
                }),

              ]),
            ),

          ]))),
        ),
      ],
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
