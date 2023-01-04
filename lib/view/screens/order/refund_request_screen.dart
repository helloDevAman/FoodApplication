import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class RefundRequestScreen extends StatefulWidget {
  final String orderId;
  const RefundRequestScreen({Key key, @required this.orderId}) : super(key: key);

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<OrderController>().selectReason(0, isUpdate: false);
    Get.find<OrderController>().pickRefundImage(true);
    Get.find<OrderController>().getRefundReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'refund_request'.tr),
      body: GetBuilder<OrderController>(
        builder: (orderController) {
          return Center(
            child: (orderController.refundReasons != null && orderController.refundReasons.isNotEmpty) ? Container(
              width: context.width > 700 ? 700 : context.width,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              alignment: Alignment.center,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('what_is_wrong_with_this_order'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: Border.all(color: Theme.of(context).disabledColor)),
                        child: DropdownButton<String>(
                          value: orderController.refundReasons[orderController.selectedReasonIndex],
                          items: orderController.refundReasons.map((String items) {
                            return DropdownMenuItem(value: items, child: Text(items.tr));
                          }).toList(),
                          onChanged: (value){
                            orderController.selectReason(orderController.refundReasons.indexOf(value));
                            if(_noteController.text.isNotEmpty){
                              _noteController.text = '';
                            }
                            if(orderController.refundImage != null){
                              orderController.pickRefundImage(true);
                            }
                          },
                          isExpanded: true,
                          underline: SizedBox(),
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      orderController.selectedReasonIndex != 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('additional_note'.tr, style: robotoMedium),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), border: Border.all(color: Theme.of(context).disabledColor)),
                          child: CustomTextField(
                            controller: _noteController,
                            hintText: 'ex_please_provide_any_note'.tr,
                            maxLines: 3,
                            inputType: TextInputType.multiline,
                            inputAction: TextInputAction.newline,
                            capitalization: TextCapitalization.sentences,
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        DottedBorder(
                          color: Theme.of(context).disabledColor,
                          strokeWidth: 2,
                          strokeCap: StrokeCap.butt,
                          dashPattern: [8, 5],
                          padding: EdgeInsets.all(0),
                          borderType: BorderType.RRect,
                          radius: Radius.circular(Dimensions.RADIUS_SMALL),
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              child: orderController.refundImage != null ? GetPlatform.isWeb ? Image.network(
                                orderController.refundImage.path, width: context.width, height: 150, fit: BoxFit.cover,
                              ) : Image.file(
                                File(orderController.refundImage.path), width: context.width, height: 150, fit: BoxFit.cover,
                              ) : InkWell(
                                onTap: () => orderController.pickRefundImage(false),
                                child: Container(
                                  width: context.width, height: 150, alignment: Alignment.center,
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                    Icon(Icons.cloud_download_rounded, size: 34, color: Theme.of(context).disabledColor),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                                    Text('upload_image'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).disabledColor)),
                                  ]),
                                ),
                              ),
                            ),
                            orderController.refundImage != null ? Positioned(
                              bottom: 0, right: 0, top: 0, left: 0,
                              child: InkWell(
                                onTap: () => orderController.pickRefundImage(false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Theme.of(context).disabledColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                  ),
                                ),
                              ),
                            ) : SizedBox(),
                          ]),
                        ),
                      ]) : SizedBox(),

                    ]),
                  ),
                ),

                !orderController.isLoading ? CustomButton(
                  buttonText: 'submit_refund_request'.tr,
                  onPressed: () => orderController.submitRefundRequest(_noteController.text.trim(), widget.orderId),
                ) : Center(child: CircularProgressIndicator()),

              ]),
            ) : CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
