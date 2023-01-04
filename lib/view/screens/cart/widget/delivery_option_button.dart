import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final String image;
  final double charge;
  final bool isFree;
  final int index;
  DeliveryOptionButton({@required this.value, @required this.title, @required this.charge, @required this.isFree, @required this.image, @required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _select = orderController.deliverySelectIndex == index;
        return InkWell(
          onTap: () {
            orderController.setOrderType(value);
            orderController.selectDelivery(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: _select ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)
            ),
            child: Row(
              children: [
                // Radio(
                //   value: value,
                //   groupValue: orderController.orderType,
                //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //   onChanged: (String value) => orderController.setOrderType(value),
                //   activeColor: Theme.of(context).primaryColor,
                // ),
                SizedBox(height: 16, width: 16, child: Image.asset(image, color: _select ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                Text(title, style: robotoRegular.copyWith(color: _select ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),
                SizedBox(width: 5),

                // Text(
                //   '(${(value == 'take_away' || isFree) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})',
                //   style: robotoMedium,
                // ),

              ],
            ),
          ),
        );
      },
    );
  }
}
