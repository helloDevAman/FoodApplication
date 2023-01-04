import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isRestaurant;
  FavItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH, child: ProductView(
                isRestaurant: isRestaurant, products: wishController.wishProductList, restaurants: wishController.wishRestList,
                noDataText: 'no_wish_data_found'.tr,
              ),
            )),
          ),
        );
      }),
    );
  }
}
