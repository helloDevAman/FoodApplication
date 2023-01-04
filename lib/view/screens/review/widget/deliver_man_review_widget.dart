import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/data/model/body/review_body.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/my_text_field.dart';
import 'package:efood_multivendor/view/screens/review/widget/delivery_man_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan deliveryMan;
  final String orderID;
  DeliveryManReviewWidget({@required this.deliveryMan, @required this.orderID});

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Scrollbar(child: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : SizedBox(),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                blurRadius: 5, spreadRadius: 1,
              )],
            ),
            child: Column(children: [
              Text(
                'rate_his_service'.tr,
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return InkWell(
                      child: Icon(
                        productController.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                        size: 25,
                        color: productController.deliveryManRating < (i + 1) ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        productController.setDeliveryManRating(i + 1);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text(
                'share_your_opinion'.tr,
                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              MyTextField(
                maxLines: 5,
                capitalization: TextCapitalization.sentences,
                controller: _controller,
                hintText: 'write_your_review_here'.tr,
                fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
              ),
              SizedBox(height: 40),

              // Submit button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Column(
                  children: [
                    !productController.isLoading ? CustomButton(
                      buttonText: 'submit'.tr,
                      onPressed: () {
                        if (productController.deliveryManRating == 0) {
                          showCustomSnackBar('give_a_rating'.tr);
                        } else if (_controller.text.isEmpty) {
                          showCustomSnackBar('write_a_review');
                        } else {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          ReviewBody reviewBody = ReviewBody(
                            deliveryManId: widget.deliveryMan.id.toString(),
                            rating: productController.deliveryManRating.toString(),
                            comment: _controller.text,
                            orderId: widget.orderID,
                          );
                          productController.submitDeliveryManReview(reviewBody).then((value) {
                            if (value.isSuccess) {
                              showCustomSnackBar(value.message, isError: false);
                              _controller.text = '';
                            } else {
                              showCustomSnackBar(value.message);
                            }
                          });
                        }
                      },
                    ) : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ]),
          ),

        ]))),
      ));
    });
  }
}
