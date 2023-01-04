import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int index;
  PaymentButton({@required this.index, @required this.icon, @required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom:  Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () => orderController.setPaymentMethod(index),
          child: Container(
            width: 200, padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              border: Border.all(color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 1.5)
              // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
            ),
            child: Row(children: [
              Image.asset(
                icon, width: 20, height: 20,
                color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Text(title, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor)),

            ]),

            /*child: ListTile(
              leading: Image.asset(
                icon, width: 20, height: 20,
                color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              subtitle: Text(
                subtitle,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              trailing: _selected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
            ),*/
          ),
        ),
      );
    });
  }
}
