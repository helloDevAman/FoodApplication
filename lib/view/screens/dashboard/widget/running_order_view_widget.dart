import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningOrderViewWidget extends StatelessWidget {
  const RunningOrderViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      String _orderStatus = orderController.runningOrderList != null ? orderController.runningOrderList[orderController.runningOrderIndex].orderStatus : '';
      print('out for delivery: $_orderStatus');
      int _status = 0;

      if(_orderStatus == AppConstants.PENDING){
        _status = 1;
      }else if(_orderStatus == AppConstants.ACCEPTED || _orderStatus == AppConstants.PROCESSING || _orderStatus == AppConstants.CONFIRMED){
        _status = 2;
      }else if(_orderStatus == AppConstants.HANDOVER || _orderStatus == AppConstants.PICKED_UP){
        _status = 3;
      }
        return (_status == 1 || _status == 2 || _status == 3) ? InkWell(
          onTap: (){
            Get.toNamed(
              RouteHelper.getOrderDetailsRoute(orderController.runningOrderList[orderController.runningOrderIndex].id),
              arguments: OrderDetailsScreen(orderId: orderController.runningOrderList[orderController.runningOrderIndex].id, orderModel: orderController.runningOrderList[orderController.runningOrderIndex]),
            );
            orderController.closeRunningOrder(true);
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Color(0xFF2A2A2A).withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5))],
            ),
            child:  Column(children: [

              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: Row( crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Center(
                    child: Image.asset( _status == 2 ? _orderStatus == AppConstants.CONFIRMED || _orderStatus == AppConstants.ACCEPTED ? Images.processing_gif
                        : Images.cooking_gif : _status == 3
                        ? _orderStatus == AppConstants.HANDOVER ? Images.handover_gif : Images.on_the_way_gif : Images.pending_gif,
                        height: _status == 1 ? 40 : 70, width: _status == 1 ? 40 : 70, fit: BoxFit.fill),
                  ),

                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                       Row( mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('order_status'.tr + ': ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        Text( orderController.runningOrderList != null ?orderController.runningOrderList[orderController.runningOrderIndex].orderStatus.tr : '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                      ]) ,
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Text(
                        _status == 1 ? 'the_restaurant_will_soon_accept_your_order'.tr : _status == 2 ? _orderStatus == AppConstants.ACCEPTED
                          ? 'deliveryman_accept_your_order'.tr : 'deliveryman_will_soon_pick_your_order'.tr : 'deliveryman_just_picked_your_order'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                    ]),
                  ),

                  InkWell(
                      onTap: () => orderController.closeRunningOrder(true),
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Text('ok'.tr, style: robotoBlack.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
                      )
                  ),

                ]),
              )),

              SizedBox(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                    vertical: Dimensions.PADDING_SIZE_DEFAULT),
                  child: Row(children: [
                    Expanded(child: trackView(context, status: _status >= 1 ? true : false)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Expanded(child: trackView(context, status: _status >= 2 ? true : false)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Expanded(child: trackView(context, status: _status >= 3 ? true : false)),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Expanded(child: trackView(context, status: _status >= 4 ? true : false)),
                  ]),
                ),
              )

            ]) ,
          ),
        ) : SizedBox();
      }
    );
  }

  Widget trackView(BuildContext context, {@required bool status}) {
    return Container(height: 5, decoration: BoxDecoration(color: status ? Theme.of(context).primaryColor
        : Theme.of(context).disabledColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)));
  }
}
