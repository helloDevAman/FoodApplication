
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wallet_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletBottomSheet extends StatefulWidget {
  final bool fromWallet;
  const WalletBottomSheet({Key key, @required this.fromWallet}) : super(key: key);

  @override
  State<WalletBottomSheet> createState() => _WalletBottomSheetState();
}

class _WalletBottomSheetState extends State<WalletBottomSheet> {

  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.fromWallet);

    int _exchangePointRate = Get.find<SplashController>().configModel.loyaltyPointExchangeRate;
    int _minimumExchangePoint = Get.find<SplashController>().configModel.minimumPointToTransfer;

    return Container(
      width: 550,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_LARGE)),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Text('your_loyalty_point_will_convert_to_currency_and_transfer_to_your_wallet'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Text('$_exchangePointRate ' + 'points'.tr + '= ${PriceConverter.convertPrice(1)}',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), border: Border.all(color: Theme.of(context).primaryColor,width: 0.3)),
            child: CustomTextField(
              hintText: '0',
              controller: _amountController,
              inputType: TextInputType.phone,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<WalletController>(
            builder: (walletController) {
              return !walletController.isLoading ? CustomButton(
                  buttonText: 'convert'.tr,
                  onPressed: () {
                    if(_amountController.text.isEmpty) {
                      showCustomSnackBar('input_field_is_empty'.tr);
                    }else{
                      int _amount = int.parse(_amountController.text.trim());
                      print(_amount);

                      if(_amount <_minimumExchangePoint){
                        showCustomSnackBar('please_exchange_more_then'.tr + ' $_minimumExchangePoint ' + 'points'.tr);
                      } else {
                          walletController.pointToWallet(_amount, widget.fromWallet);
                        }
                    }
                },
              ) : Center(child: CircularProgressIndicator());
            }
          ),
        ]),
      ),
    );
  }
}
