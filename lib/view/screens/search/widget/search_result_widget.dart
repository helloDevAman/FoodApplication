import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/search/widget/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  SearchResultWidget({@required this.searchText});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<SearchController>(builder: (searchController) {
        bool _isNull = true;
        int _length = 0;
        if(searchController.isRestaurant) {
          _isNull = searchController.searchRestList == null;
          if(!_isNull) {
            _length = searchController.searchRestList.length;
          }
        }else {
          _isNull = searchController.searchProductList == null;
          if(!_isNull) {
            _length = searchController.searchProductList.length;
          }
        }
        return _isNull ? SizedBox() : Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(children: [
            Text(
              _length.toString(),
              style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              'results_found'.tr,
              style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        )));
      }),

      Center(child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).cardColor,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          tabs: [
            Tab(text: 'food'.tr),
            Tab(text: 'restaurants'.tr),
          ],
        ),
      )),

      Expanded(child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            Get.find<SearchController>().setRestaurant(_tabController.index == 1);
            Get.find<SearchController>().searchData(widget.searchText);
          }
          return false;
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            ItemView(isRestaurant: false),
            ItemView(isRestaurant: true),
          ],
        ),
      )),

    ]);
  }
}
