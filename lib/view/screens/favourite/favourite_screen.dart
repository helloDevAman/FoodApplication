import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:efood_multivendor/view/screens/favourite/widget/fav_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'favourite'.tr, isBackButtonExist: false),
      body: Get.find<AuthController>().isLoggedIn() ? SafeArea(child: Column(children: [

        Container(
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
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: [
            FavItemView(isRestaurant: false),
            FavItemView(isRestaurant: true),
          ],
        )),

      ])) : NotLoggedInScreen(),
    );
  }
}
