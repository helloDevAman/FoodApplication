import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  Widget build(BuildContext context) {
    String _data = htmlType == HtmlType.TERMS_AND_CONDITION ? Get.find<SplashController>().configModel.termsAndConditions
        : htmlType == HtmlType.ABOUT_US ? Get.find<SplashController>().configModel.aboutUs
        : htmlType == HtmlType.PRIVACY_POLICY ? Get.find<SplashController>().configModel.privacyPolicy
        : htmlType == HtmlType.REFUND_POLICY ? Get.find<SplashController>().configModel.refundPolicyData
        : htmlType == HtmlType.CANCELLATION_POLICY ? Get.find<SplashController>().configModel.cancellationPolicyData
        : htmlType == HtmlType.SHIPPING_POLICY ? Get.find<SplashController>().configModel.shippingPolicyData
        : null;

    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(GetPlatform.isWeb) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = Dimensions.WEB_MAX_WIDTH.toString();
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: CustomAppBar(title: htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
          : htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : htmlType == HtmlType.PRIVACY_POLICY
          ? 'privacy_policy'.tr :  htmlType == HtmlType.SHIPPING_POLICY ? 'shipping_policy'.tr
          : htmlType == HtmlType.REFUND_POLICY ? 'refund_policy'.tr :  htmlType == HtmlType.CANCELLATION_POLICY
          ? 'cancellation_policy'.tr  : 'no_data_found'.tr),
      body: Center(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          height: MediaQuery.of(context).size.height,
          color: GetPlatform.isWeb ? Colors.white : Theme.of(context).cardColor,
          child: GetPlatform.isWeb ? Column(
            children: [
              Container(
                height: 50, alignment: Alignment.center,
                child: SelectableText(htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
                    : htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : htmlType == HtmlType.PRIVACY_POLICY
                    ? 'privacy_policy'.tr : htmlType == HtmlType.SHIPPING_POLICY ? 'shipping_policy'.tr
                    : htmlType == HtmlType.REFUND_POLICY ? 'refund_policy'.tr :  htmlType == HtmlType.CANCELLATION_POLICY
                    ? 'cancellation_policy'.tr  : 'no_data_found'.tr,
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black),
                ),
              ),
              Expanded(child: IgnorePointer(child: HtmlElementView(viewType: _viewID, key: Key(htmlType.toString())))),
            ],
          ) : SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: HtmlWidget(
              _data ?? '',
              key: Key(htmlType.toString()),
              onTapUrl: (String url) {
                return launchUrlString(url, mode: LaunchMode.externalApplication);
              },
            ),
          ),
        ),
      ),
    );
  }
}