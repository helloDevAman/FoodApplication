import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/paginated_list_view.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantProductSearchScreen extends StatefulWidget {
  final String storeID;
  const RestaurantProductSearchScreen({Key key, @required this.storeID}) : super(key: key);

  @override
  State<RestaurantProductSearchScreen> createState() => _RestaurantProductSearchScreenState();
}

class _RestaurantProductSearchScreenState extends State<RestaurantProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>().initSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          height: 60 + context.mediaQueryPadding.top, width: Dimensions.WEB_MAX_WIDTH,
          padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
          color: Theme.of(context).cardColor,
          alignment: Alignment.center,
          child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [

              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
              ),

              Expanded(child: TextField(
                controller: _searchController,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                textInputAction: TextInputAction.search,
                cursorColor: Theme.of(context).primaryColor,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'search_item_in_store'.tr,
                  hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                  isDense: true,
                  contentPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Theme.of(context).hintColor, size: 25),
                    onPressed: () => Get.find<RestaurantController>().getStoreSearchItemList(
                      _searchController.text.trim(), widget.storeID, 1, Get.find<RestaurantController>().searchType,
                    ),
                  ),
                ),
                onSubmitted: (text) => Get.find<RestaurantController>().getStoreSearchItemList(
                  _searchController.text.trim(), widget.storeID, 1, Get.find<RestaurantController>().searchType,
                ),
              )),

            ]),
          )),
        ),
        preferredSize: Size(Dimensions.WEB_MAX_WIDTH, 60),
      ),

      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return SingleChildScrollView(
          controller: _scrollController,
          padding: ResponsiveHelper.isDesktop(context) ? null : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Center(
            child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: PaginatedListView(
              scrollController: _scrollController,
              onPaginate: (int offset) => restaurantController.getStoreSearchItemList(
                restaurantController.searchText, widget.storeID, offset, restaurantController.searchType,
              ),
              totalSize: restaurantController.restaurantSearchProductModel != null ? restaurantController.restaurantSearchProductModel.totalSize : null,
              offset: restaurantController.restaurantSearchProductModel != null ? restaurantController.restaurantSearchProductModel.offset : 1,
              productView: ProductView(
                isRestaurant: false, restaurants: null,
                products: restaurantController.restaurantSearchProductModel != null ? restaurantController.restaurantSearchProductModel.products : null,
                inRestaurantPage: true, type: restaurantController.searchText.isNotEmpty ? restaurantController.searchType : null, onVegFilterTap: (String type) {
                restaurantController.getStoreSearchItemList(restaurantController.searchText, widget.storeID, 1, type);
              },
              ),
            )),
          ),
        );
      }),

    );
  }
}
