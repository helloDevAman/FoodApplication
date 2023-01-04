
import 'package:efood_multivendor/data/model/response/wallet_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class HistoryItem extends StatelessWidget {
  final int index;
  final bool fromWallet;
  final List<Transaction> data;
  const HistoryItem({Key key, @required this.index, @required this.fromWallet, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              fromWallet ? Text(data[index].transactionType == 'order_place'
                  ? PriceConverter.convertPrice(data[index].debit + data[index].adminBonus)
                  : PriceConverter.convertPrice(data[index].credit + data[index].adminBonus),
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis,
              ) : Row(children: [
                Text(data[index].transactionType == 'point_to_wallet'? data[index].debit.toStringAsFixed(0)
                    : data[index].credit.toStringAsFixed(0),
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                Text('points'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
                )]),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text(data[index].transactionType.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(DateConverter.dateToDateAndTimeAm(data[index].createdAt),style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text( fromWallet ? data[index].transactionType == 'order_place' ? 'debit' : 'credit' : data[index].transactionType == 'point_to_wallet' ? 'debit' : 'credit',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: fromWallet ? data[index].transactionType == 'order_place'
                      ? Colors.red : Colors.green : data[index].transactionType == 'point_to_wallet' ? Colors.red : Colors.green),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),

        ],),

      Padding(
        padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
        child: Divider(color: Theme.of(context).disabledColor),
      ),
    ]);
  }
}
