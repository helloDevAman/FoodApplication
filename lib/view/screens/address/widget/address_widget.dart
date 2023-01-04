import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function onRemovePressed;
  final Function onEditPressed;
  final Function onTap;
  AddressWidget({@required this.address, @required this.fromAddress, this.onRemovePressed, this.onEditPressed,
    this.onTap, this.fromCheckout = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_DEFAULT
              : Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: fromCheckout ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: fromCheckout ? null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
          ),
          child: Row(children: [

            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(
                    address.addressType == 'home' ? Icons.home_filled : address.addressType == 'office'
                        ? Icons.work : Icons.location_on,
                    size: ResponsiveHelper.isDesktop(context) ? 30 : 20, color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Text(
                    address.addressType.tr,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                Text(
                  address.address,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ]),
            ),
            // fromAddress ? IconButton(
            //   icon: Icon(Icons.edit, color: Colors.blue, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
            //   onPressed: onEditPressed,
            // ) : SizedBox(),
            fromAddress ? IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
              onPressed: onRemovePressed,
            ) : SizedBox(),
          ]),
        ),
      ),
    );
  }
}