import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  final String restaurantID;
  ReviewScreen({@required this.restaurantID});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>().getRestaurantReviewList(widget.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'restaurant_reviews'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return restController.restaurantReviewList != null ? restController.restaurantReviewList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await restController.getRestaurantReviewList(widget.restaurantID);
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                childAspectRatio: (1/0.2), crossAxisSpacing: 10, mainAxisSpacing: 10,
              ),
              itemCount: restController.restaurantReviewList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              itemBuilder: (context, index) {
                return ReviewWidget(
                  review: restController.restaurantReviewList[index],
                  hasDivider: index != restController.restaurantReviewList.length-1,
                );
              },
            )))),
        ) : Center(child: NoDataScreen(text: 'no_review_found'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
