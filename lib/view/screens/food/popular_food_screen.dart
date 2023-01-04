import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularFoodScreen extends StatefulWidget {
  final bool isPopular;
  PopularFoodScreen({@required this.isPopular});

  @override
  State<PopularFoodScreen> createState() => _PopularFoodScreenState();
}

class _PopularFoodScreenState extends State<PopularFoodScreen> {

  @override
  void initState() {
    super.initState();

    if(widget.isPopular) {
      Get.find<ProductController>().getPopularProductList(true, Get.find<ProductController>().popularType, false);
    }else {
      Get.find<ProductController>().getReviewedProductList(true, Get.find<ProductController>().reviewType, false);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: widget.isPopular ? 'popular_foods_nearby'.tr : 'best_reviewed_food'.tr, showCart: true),
      body: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<ProductController>(builder: (productController) {
          return ProductView(
            isRestaurant: false, restaurants: null, type: widget.isPopular ? productController.popularType : productController.reviewType,
            products: widget.isPopular ? productController.popularProductList : productController.reviewedProductList,
            onVegFilterTap: (String type) {
              if(widget.isPopular) {
                productController.getPopularProductList(true, type, true);
              }else {
                productController.getReviewedProductList(true, type, true);
              }
            },
          );
        }),
      )))),
    );
  }
}
