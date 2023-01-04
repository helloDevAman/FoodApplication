import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  ChooseLanguageScreen({this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (fromMenu || ResponsiveHelper.isDesktop(context)) ? CustomAppBar(title: 'language'.tr, isBackButtonExist: true) : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [

            Expanded(child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Center(child: Image.asset(Images.logo, width: 100)),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(child: Image.asset(Images.logo_name, width: 100)),

                      //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                      SizedBox(height: 30),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text('select_language'.tr, style: robotoMedium),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                          childAspectRatio: (1/1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController, index: index,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Text('you_can_change_language'.tr, style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                      )),

                    ]),
                  )),
                ),
              ),
            )),

            CustomButton(
              buttonText: 'save'.tr,
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              onPressed: () {
                if(localizationController.languages.length > 0 && localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex].languageCode,
                    AppConstants.languages[localizationController.selectedIndex].countryCode,
                  ));
                  if (fromMenu) {
                    Navigator.pop(context);
                  } else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                }else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ]);
        }),
      ),
    );
  }
}
