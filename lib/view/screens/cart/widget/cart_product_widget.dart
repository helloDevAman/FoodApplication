import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartProductWidget({@required this.cart, @required this.cartIndex, @required this.isAvailable, @required this.addOns});

  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.product.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText + '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if(cart.variations.length > 0) {
      for(int index=0; index<cart.variations.length; index++) {
        if(cart.variations[index].contains(true)) {
          _variationText += '${_variationText.isNotEmpty ? ', ' : ''}${cart.product.variations[index].name} (';
          for(int i=0; i<cart.variations[index].length; i++) {
            if(cart.variations[index][i]) {
              _variationText += '${_variationText.endsWith('(') ? '' : ', '}${cart.product.variations[index].variationValues[i].level}';
            }
          }
          _variationText += ')';
        }
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
          ) : showDialog(context: context, builder: (con) => Dialog(
            child: ProductBottomSheet(product: cart.product, cartIndex: cartIndex, cart: cart),
          ));
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
          child: Stack(children: [
            Positioned(
              top: 0, bottom: 0, right: 0, left: 0,
              child: Icon(Icons.delete, color: Colors.white, size: 50),
            ),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) => Get.find<CartController>().removeFromCart(cartIndex),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 800 : 200],
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Column(
                  children: [

                    Row(children: [
                      (cart.product.image != null && cart.product.image.isNotEmpty) ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}',
                              height: 65, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          isAvailable ? SizedBox() : Positioned(
                            top: 0, left: 0, bottom: 0, right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.black.withOpacity(0.6)),
                              child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                                color: Colors.white, fontSize: 8,
                              )),
                            ),
                          ),
                        ],
                      ) : SizedBox.shrink(),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            cart.product.name,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          RatingBar(rating: cart.product.avgRating, size: 12, ratingCount: cart.product.ratingCount),
                          SizedBox(height: 5),
                          Text(
                            PriceConverter.convertPrice(cart.discountedPrice+cart.discountAmount),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ]),
                      ),

                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Get.find<SplashController>().configModel.toggleVegNonVeg ? Container(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            cart.product.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                          ),
                        ) : SizedBox(),
                        SizedBox(height: Get.find<SplashController>().configModel.toggleVegNonVeg ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                        Row(children: [
                          QuantityButton(
                            onTap: () {
                              if (cart.quantity > 1) {
                                Get.find<CartController>().setQuantity(false, cart);
                              }else {
                                Get.find<CartController>().removeFromCart(cartIndex);
                              }
                            },
                            isIncrement: false,
                          ),
                          Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                          QuantityButton(
                            onTap: () => Get.find<CartController>().setQuantity(true, cart),
                            isIncrement: true,
                          ),
                        ]),
                      ]),

                      !ResponsiveHelper.isMobile(context) ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: IconButton(
                          onPressed: () {
                            Get.find<CartController>().removeFromCart(cartIndex);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ) : SizedBox(),

                    ]),

                    _addOnText.isNotEmpty ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(children: [
                        SizedBox(width: 80),
                        Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Flexible(child: Text(
                          _addOnText,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    ) : SizedBox(),

                    (_variationText != '' && cart.product.variations != null && cart.product.variations.length > 0) ? Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 80),
                        Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        Flexible(child: Text(_variationText, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        ),
                      ]),
                    ) : SizedBox(),

                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
