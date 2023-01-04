import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/bottom_cart_widget.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/search/widget/filter_widget.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_field.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn) {
      Get.find<SearchController>().getSuggestedFoods();
    }
    Get.find<SearchController>().getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Get.find<SearchController>().isSearchMode) {
          return true;
        }else {
          Get.find<SearchController>().setSearchMode(true);
          return false;
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        body: SafeArea(child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<SearchController>(builder: (searchController) {
            _searchController.text = searchController.searchText;
            return Column(children: [

              Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(children: [
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: SearchField(
                  controller: _searchController,
                  hint: 'search_food_or_restaurant'.tr,
                  suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
                  iconPressed: () => _actionSearch(searchController, false),
                  onSubmit: (text) => _actionSearch(searchController, true),
                )),
                CustomButton(
                  onPressed: () => searchController.isSearchMode ? Get.back() : searchController.setSearchMode(true),
                  buttonText: 'cancel'.tr,
                  transparent: true,
                  width: 80,
                ),
              ]))),

              Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  searchController.historyList.length > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('history'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    InkWell(
                      onTap: () => searchController.clearSearchAddress(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: 4),
                        child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                        )),
                      ),
                    ),
                  ]) : SizedBox(),

                  ListView.builder(
                    itemCount: searchController.historyList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Row(children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => searchController.searchData(searchController.historyList[index]),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Text(
                                  searchController.historyList[index],
                                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => searchController.removeHistory(index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                            ),
                          )
                        ]),
                        index != searchController.historyList.length-1 ? Divider() : SizedBox(),
                      ]);
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  (_isLoggedIn && searchController.suggestedFoodList != null) ? Text(
                    'suggestions'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ) : SizedBox(),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  (_isLoggedIn && searchController.suggestedFoodList != null) ? searchController.suggestedFoodList.length > 0 ?  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 4, childAspectRatio: (1/ 0.4),
                      mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL, crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchController.suggestedFoodList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                            ProductBottomSheet(product: searchController.suggestedFoodList[index]),
                            backgroundColor: Colors.transparent, isScrollControlled: true,
                          ) : Get.dialog(
                            Dialog(child: ProductBottomSheet(product: searchController.suggestedFoodList[index])),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          ),
                          child: Row(children: [
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              child: CustomImage(
                                image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                    '/${searchController.suggestedFoodList[index].image}',
                                width: 45, height: 45, fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Expanded(child: Text(
                              searchController.suggestedFoodList[index].name,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            )),
                          ]),
                        ),
                      );
                    },
                  ) : Padding(padding: EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : SizedBox(),
                ]))),
              ) : SearchResultWidget(searchText: _searchController.text.trim())),

            ]);
          }),
        )),

        bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.length > 0 && !ResponsiveHelper.isDesktop(context) ? BottomCartWidget() : SizedBox();
        }),
      ),
    );
  }

  void _actionSearch(SearchController searchController, bool isSubmit) {
    if(searchController.isSearchMode || isSubmit) {
      if(_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      }else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    }else {
      List<double> _prices = [];
      if(!searchController.isRestaurant) {
        searchController.allProductList.forEach((product) => _prices.add(product.price));
        _prices.sort();
      }
      double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;
      Get.dialog(FilterWidget(maxValue: _maxValue, isRestaurant: searchController.isRestaurant));
    }
  }
}
