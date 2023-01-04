import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/address_details.dart';
import 'package:efood_multivendor/view/base/custom_divider.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackDetailsView extends StatelessWidget {
  final OrderModel track;
  final Function callback;
  TrackDetailsView({@required this.track, @required this.callback});

  @override
  Widget build(BuildContext context) {
    double _distance = 0;
    bool _takeAway = track.orderType == 'take_away';
    if(track.deliveryMan != null) {
      _distance = Geolocator.distanceBetween(
        double.parse(track.deliveryAddress.latitude), double.parse(track.deliveryAddress.longitude),
        double.parse(track.deliveryMan.lat ?? '0'), double.parse(track.deliveryMan.lng ?? '0'),
      ) / 1000;
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).cardColor,
      ),
      alignment: Alignment.center,
      child: (!_takeAway && track.deliveryMan == null) ? Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Text(
          'delivery_man_not_assigned'.tr, style: robotoMedium, textAlign: TextAlign.center,
        ),
      ) : Column(children: [

        Text('trip_route'.tr, style: robotoMedium),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Row(children: [

          Expanded(flex: 3, child: Text(
            _takeAway ? track.deliveryAddress.address : track.deliveryMan.location ,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            maxLines: 5, overflow: TextOverflow.ellipsis,
          )),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          SizedBox(width: 80, child: CustomDivider(color: Theme.of(context).primaryColor, height: 2)),

          Container(height: 10, width: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

          Expanded(
              flex: 5,
              child: _takeAway ? Text(track.restaurant != null ? track.restaurant.address : '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ) : AddressDetails(addressDetails: track.deliveryAddress),
          ),

        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        _takeAway ? InkWell(
          onTap: () async {
            String url ='https://www.google.com/maps/dir/?api=1&destination=${track.restaurant != null ? track.restaurant.latitude : '0'}'
                ',${track.restaurant != null ? track.restaurant.longitude : '0'}&mode=d';
            if (await canLaunchUrlString(url)) {
              Get.find<OrderController>().cancelTimer();
              await launchUrlString(url, mode: LaunchMode.externalApplication);
              Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel, orderId: track.id.toString());
            }else {
              showCustomSnackBar('unable_to_launch_google_map'.tr);
            }
          },
          child: Column(children: [
            Icon(Icons.directions, size: 25, color: Theme.of(context).primaryColor),
            Text(
              'direction'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          ]),
        ) : Column(children: [
          Image.asset(Images.route, height: 20, width: 20, color: Theme.of(context).primaryColor),
          Text(
            '${_distance.toStringAsFixed(2)} ${'km'.tr}',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        ]),

        Align(alignment: Alignment.centerLeft, child: Text(
          _takeAway ? 'restaurant'.tr : 'delivery_man'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
        )),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Row(children: [
          ClipOval(child: CustomImage(
            image: '${_takeAway ? Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl
                : Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${_takeAway ? track.restaurant != null ? track.restaurant.logo : ''
                : track.deliveryMan.image}',
            height: 35, width: 35, fit: BoxFit.cover,
          )),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _takeAway ? track.restaurant != null ? track.restaurant.name : 'no_restaurant_data_found'.tr : '${track.deliveryMan.fName} ${track.deliveryMan.lName}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
            ),
            RatingBar(
              rating: _takeAway ? track.restaurant != null ? track.restaurant.avgRating : 0 : track.deliveryMan.avgRating, size: 10,
              ratingCount: _takeAway ? track.restaurant != null ? track.restaurant.ratingCount : 0 : track.deliveryMan.ratingCount,
            ),
          ])),
          InkWell(
            onTap: () async {
              if(await canLaunchUrlString('tel:${_takeAway ? track.restaurant != null ? track.restaurant.phone : '' : track.deliveryMan.phone}')) {
                launchUrlString('tel:${_takeAway ? track.restaurant != null ? track.restaurant.phone : '' : track.deliveryMan.phone}', mode: LaunchMode.externalApplication);
              }else {
                showCustomSnackBar('${'can_not_launch'.tr} ${_takeAway ? track.restaurant != null ? track.restaurant.phone : '' : track.deliveryMan.phone}');
              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Colors.green,
              ),
              child: Text(
                'call'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
              ),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          InkWell(
            onTap: callback,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Get.context.width >= 1300 ? 7 : Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Colors.green,
              ),
              child: Icon(Icons.chat, size: 12, color: Theme.of(context).cardColor),
            ),
          ),

        ]),

      ]),
    );
  }
}
