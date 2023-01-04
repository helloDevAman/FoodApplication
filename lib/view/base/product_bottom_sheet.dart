
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/discount_tag_without_image.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inRestaurantPage;
  ProductBottomSheet({@required this.product, this.isCampaign = false, this.cart, this.cartIndex, this.inRestaurantPage = false});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {

  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<ProductController>(builder: (productController) {
        double _price = widget.product.price;
        double _variationPrice = 0;
        if(widget.product.variations != null){
          for(int index = 0; index< widget.product.variations.length; index++) {
            for(int i=0; i<widget.product.variations[index].variationValues.length; i++) {
              if(productController.selectedVariations[index][i]) {
                _variationPrice += widget.product.variations[index].variationValues[i].optionPrice;
              }
            }
          }
        }
        double _discount = (widget.isCampaign || widget.product.restaurantDiscount == 0) ? widget.product.discount : widget.product.restaurantDiscount;
        String _discountType = (widget.isCampaign || widget.product.restaurantDiscount == 0) ? widget.product.discountType : 'percent';
        double priceWithDiscount = PriceConverter.convertWithDiscount(_price, _discount, _discountType);
        double priceWithQuantity = priceWithDiscount * productController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.product.addOns.length; index++) {
          if (productController.addOnActiveList[index]) {
            addonsCost = addonsCost + (widget.product.addOns[index].price * productController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(id: widget.product.addOns[index].id, quantity: productController.addOnQtyList[index]));
            _addOnsList.add(widget.product.addOns[index]);
          }
        }
        double priceWithAddonsVariation = addonsCost + (PriceConverter.convertWithDiscount(_variationPrice + _price , _discount, _discountType) * productController.quantity);
        double priceWithAddonsVariationWithoutDiscount = ((_price + _variationPrice) * productController.quantity) + addonsCost;
        double priceWithVariation = _price + _variationPrice;
        bool _isAvailable = DateConverter.isAvailable(widget.product.availableTimeStarts, widget.product.availableTimeEnds);

        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

            InkWell(onTap: () => Get.back(), child: Padding(
              padding:  EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Icon(Icons.close),
            )),

            Padding(
              padding: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_DEFAULT, top: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.PADDING_SIZE_DEFAULT,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                ///Product
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  (widget.product.image != null && widget.product.image.isNotEmpty) ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: widget.isCampaign ? null : () {
                        if(!widget.isCampaign) {
                          Get.toNamed(RouteHelper.getItemImagesRoute(widget.product));
                        }
                      },
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: CustomImage(
                            image: '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl
                                : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                            width: ResponsiveHelper.isMobile(context) ? 100 : 140,
                            height: ResponsiveHelper.isMobile(context) ? 100 : 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        DiscountTag(discount: _discount, discountType: _discountType, fromTop: 20),
                      ]),
                    ),
                  ) : SizedBox.shrink(),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        widget.product.name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {
                          if(widget.inRestaurantPage) {
                            Get.back();
                          }else {
                            Get.offNamed(RouteHelper.getRestaurantRoute(widget.product.restaurantId));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Text(
                            widget.product.restaurantName,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      RatingBar(rating: widget.product.avgRating, size: 15, ratingCount: widget.product.ratingCount),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Text(
                        '${PriceConverter.convertPrice(_price, discount: _discount, discountType: _discountType)}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                      Row(children: [
                        _price > priceWithDiscount ? Text(
                          '${PriceConverter.convertPrice(_price)}',
                          style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough),
                        ) : SizedBox(),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        (widget.product.image != null && widget.product.image.isNotEmpty)? SizedBox.shrink()
                            : DiscountTagWithoutImage(discount: _discount, discountType: _discountType),
                      ]),

                    ]),
                  ),

                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Get.find<SplashController>().configModel.toggleVegNonVeg ? Container(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        widget.product.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                      ),
                    ) : SizedBox(),
                    SizedBox(height: Get.find<SplashController>().configModel.toggleVegNonVeg ? 50 : 0),
                    widget.isCampaign ? SizedBox(height: 25) : GetBuilder<WishListController>(builder: (wishList) {
                      return InkWell(
                        onTap: () {
                          if(Get.find<AuthController>().isLoggedIn()) {
                            wishList.wishProductIdList.contains(widget.product.id) ? wishList.removeFromWishList(widget.product.id, false)
                                : wishList.addToWishList(widget.product, null, false);
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Icon(
                          wishList.wishProductIdList.contains(widget.product.id) ? Icons.favorite : Icons.favorite_border,
                          color: wishList.wishProductIdList.contains(widget.product.id) ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                        ),
                      );
                    }),
                  ]),

                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                (widget.product.description != null && widget.product.description.isNotEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('description'.tr, style: robotoMedium),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(widget.product.description, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                ) : SizedBox(),

                /// Variation
                widget.product.variations != null ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.product.variations.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(widget.product.variations[index].name, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        Text(
                          ' (${widget.product.variations[index].required ? 'required'.tr : 'optional'.tr})',
                          style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                        ),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Row(children: [
                        (widget.product.variations[index].multiSelect) ? Text(
                          '${'you_need_to_select_minimum'.tr} ${'${widget.product.variations[index].min}'
                              ' ${'to_maximum'.tr} ${widget.product.variations[index].max} ${'options'.tr}'}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                        ) : SizedBox(),
                      ]),
                      SizedBox(height: (widget.product.variations[index].multiSelect) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: widget.product.variations[index].variationValues.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: () {
                              productController.setCartVariationIndex(index, i, widget.product, widget.product.variations[index].multiSelect);
                            },
                            child: Row(children: [

                              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                                widget.product.variations[index].multiSelect ? Checkbox(
                                  value: productController.selectedVariations[index][i],
                                  activeColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                                  onChanged:(bool newValue) {
                                    productController.setCartVariationIndex(
                                      index, i, widget.product, widget.product.variations[index].multiSelect,
                                    );
                                  },
                                  visualDensity: VisualDensity(horizontal: -3, vertical: -3),
                                ) : Radio(
                                  value: i,
                                  groupValue: productController.selectedVariations[index].indexOf(true),
                                  onChanged: (value) {
                                    productController.setCartVariationIndex(
                                      index, i,widget.product, widget.product.variations[index].multiSelect,
                                    );
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                  toggleable: false,
                                  visualDensity: VisualDensity(horizontal: -3, vertical: -3),
                                ),

                                Text(
                                  widget.product.variations[index].variationValues[i].level.trim(),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: productController.selectedVariations[index][i] ? robotoMedium : robotoRegular,
                                ),

                              ]),

                              Spacer(),

                              Text(
                                '${widget.product.variations[index].variationValues[i].optionPrice > 0 ? '+'+ PriceConverter.convertPrice(widget.product.variations[index].variationValues[i].optionPrice) : 'free'.tr}',
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: productController.selectedVariations[index][i] ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)
                                    : robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                              ),

                            ]),
                          );
                        },
                      ),

                      SizedBox(height: index != widget.product.variations.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                    ]);
                  },
                ) : SizedBox(),
                SizedBox(height: (widget.product.variations != null && widget.product.variations.length > 0) ? Dimensions.PADDING_SIZE_LARGE : 0),

                // Quantity
                Row(children: [
                  Text('quantity'.tr, style: robotoMedium),
                  Expanded(child: SizedBox()),
                  Row(children: [
                    QuantityButton(
                      onTap: () {
                        if (productController.quantity > 1) {
                          productController.setQuantity(false);
                        }
                      },
                      isIncrement: false,
                    ),
                    Text(productController.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    QuantityButton(
                      onTap: () => productController.setQuantity(true),
                      isIncrement: true,
                    ),
                  ]),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                /// Addons
                widget.product.addOns.length > 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('addons'.tr, style: robotoMedium),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: (1 / 1.1),
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.product.addOns.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!productController.addOnActiveList[index]) {
                            productController.addAddOn(true, index);
                          } else if (productController.addOnQtyList[index] == 1) {
                            productController.addAddOn(false, index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: productController.addOnActiveList[index] ? 2 : 20),
                          decoration: BoxDecoration(
                            color: productController.addOnActiveList[index] ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            border: productController.addOnActiveList[index] ? null : Border.all(color: Theme.of(context).disabledColor, width: 2),
                            boxShadow: productController.addOnActiveList[index]
                                ? [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)] : null,
                          ),
                          child: Column(children: [
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(widget.product.addOns[index].name,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(
                                    color: productController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.product.addOns[index].price > 0 ? PriceConverter.convertPrice(widget.product.addOns[index].price) : 'free'.tr,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: robotoRegular.copyWith(
                                    color: productController.addOnActiveList[index] ? Colors.white : Colors.black,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                                ),
                              ]),
                            ),
                            productController.addOnActiveList[index] ? Container(
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Theme.of(context).cardColor),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (productController.addOnQtyList[index] > 1) {
                                        productController.setAddOnQuantity(false, index);
                                      } else {
                                        productController.addAddOn(false, index);
                                      }
                                    },
                                    child: Center(child: Icon(Icons.remove, size: 15)),
                                  ),
                                ),
                                Text(
                                  productController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => productController.setAddOnQuantity(true, index),
                                    child: Center(child: Icon(Icons.add, size: 15)),
                                  ),
                                ),
                              ]),
                            )
                                : SizedBox(),
                          ]),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                ]) : SizedBox(),

                Row(children: [
                  Text('${'total_amount'.tr}:', style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(PriceConverter.convertPrice(priceWithAddonsVariation), style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    '(${PriceConverter.convertPrice(priceWithAddonsVariationWithoutDiscount)})',
                    style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                //Add to cart Button

                _isAvailable ? SizedBox() : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Column(children: [
                    Text('not_available_now'.tr, style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge,
                    )),
                    Text(
                      '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                          '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                      style: robotoRegular,
                    ),
                  ]),
                ),

                (!widget.product.scheduleOrder && !_isAvailable) ? SizedBox() : Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(50, 50),
                      backgroundColor: Theme.of(context).cardColor, shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    ),
                    onPressed: () {
                      if(widget.inRestaurantPage) {
                        Get.back();
                      }else {
                        Get.offNamed(RouteHelper.getRestaurantRoute(widget.product.restaurantId));
                      }
                    },
                    child: Image.asset(Images.house, color: Theme.of(context).primaryColor, height: 30, width: 30),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Expanded(child: CustomButton(
                    width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width / 2.0 : null,
                    buttonText: widget.isCampaign ? 'order_now'.tr : widget.cart != null ? 'update_in_cart'.tr : 'add_to_cart'.tr,
                    onPressed: () async {

                      if(widget.product.variations != null){
                        for(int index=0; index<widget.product.variations.length; index++) {
                          if(!widget.product.variations[index].multiSelect && widget.product.variations[index].required
                              && !productController.selectedVariations[index].contains(true)) {
                            _showUpperCartSnackBar('${'choose_a_variation_from'.tr} ${widget.product.variations[index].name}');
                            return;
                          }else if(widget.product.variations[index].multiSelect && (widget.product.variations[index].required
                              || productController.selectedVariations[index].contains(true)) && widget.product.variations[index].min
                              > productController.selectedVariationLength(productController.selectedVariations, index)) {
                            _showUpperCartSnackBar('${'you_need_to_select_minimum'.tr} ${widget.product.variations[index].min} '
                                '${'to_maximum'.tr} ${widget.product.variations[index].max} ${'options_from'.tr} ${widget.product.variations[index].name} ${'variation'.tr}');
                            return;
                          }
                        }
                      }
                      CartModel _cartModel = CartModel(
                        priceWithVariation, priceWithDiscount, (_price - PriceConverter.convertWithDiscount(_price, _discount, _discountType)),
                        productController.quantity, _addOnIdList, _addOnsList, widget.isCampaign, widget.product, productController.selectedVariations,
                      );

                      Get.back();
                      if(widget.isCampaign) {
                        Get.toNamed(RouteHelper.getCheckoutRoute('campaign'), arguments: CheckoutScreen(
                          fromCart: false, cartList: [_cartModel],
                        ));
                      }else {
                        if (Get.find<CartController>().existAnotherRestaurantProduct(_cartModel.product.restaurantId)) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.warning,
                            title: 'are_you_sure_to_reset'.tr,
                            description: 'if_you_continue'.tr,
                            onYesPressed: () {
                              Get.back();
                              Get.find<CartController>().removeAllAndAddToCart(_cartModel);
                              _showCartSnackBar();
                            },
                          ), barrierDismissible: false);
                        } else {
                          Get.find<CartController>().addToCart(_cartModel, widget.cartIndex != null ? widget.cartIndex : productController.cartIndex);
                          _showCartSnackBar();
                        }
                      }
                    },
                  )),
                ]),
              ]),
            ),
          ]),
        );
      }),
    );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(label: 'view_cart'.tr, textColor: Colors.white, onPressed: () {
        Get.toNamed(RouteHelper.getCartRoute());
      }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
    // Get.showSnackbar(GetSnackBar(
    //   backgroundColor: Colors.green,
    //   message: 'item_added_to_cart'.tr,
    //   mainButton: TextButton(
    //     onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
    //     child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
    //   ),
    //   onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
    //   duration: Duration(seconds: 3),
    //   maxWidth: Dimensions.WEB_MAX_WIDTH,
    //   snackStyle: SnackStyle.FLOATING,
    //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    //   borderRadius: 10,
    //   isDismissible: true,
    //   dismissDirection: DismissDirection.horizontal,
    // ));
  }

  void _showUpperCartSnackBar(String message) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.red,
      message: message,
      duration: Duration(seconds: 3),
      maxWidth: Dimensions.WEB_MAX_WIDTH,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }

}

