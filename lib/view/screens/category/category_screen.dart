import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'categories'.tr),
      body: SafeArea(child: Scrollbar(child: SingleChildScrollView(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<CategoryController>(builder: (catController) {
          return catController.categoryList != null ? catController.categoryList.length > 0 ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3,
              childAspectRatio: (1/1),
              mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
              crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
            ),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: catController.categoryList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                  catController.categoryList[index].id, catController.categoryList[index].name,
                )),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
                  ),
                  alignment: Alignment.center,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: CustomImage(
                        height: 50, width: 50, fit: BoxFit.cover,
                        image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${catController.categoryList[index].image}',
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(
                      catController.categoryList[index].name, textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),

                  ]),
                ),
              );
            },
          ) : NoDataScreen(text: 'no_category_found'.tr) : Center(child: CircularProgressIndicator());
        }),
      ))))),
    );
  }
}
