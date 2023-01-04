import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];

  List<CartModel> get cartList => _cartList;

  double _subTotal = 0;
  double _itemPrice = 0;
  double _addOns = 0;
  List<List<AddOns>> _addOnsList = [];
  List<bool> _availableList = [];

  double get subTotal => _subTotal;
  double get itemPrice => _itemPrice;
  double get addOns => _addOns;
  List<List<AddOns>> get addOnsList => _addOnsList;
  List<bool> get availableList => _availableList;


  double calculationCart(){
    _itemPrice = 0 ;
    _subTotal = 0;
    _addOns = 0;
    _availableList= [];
    _addOnsList = [];
    _cartList.forEach((cartModel) {
      List<AddOns> _addOnList = [];
      cartModel.addOnIds.forEach((addOnId) {
        for(AddOns addOns in cartModel.product.addOns) {
          if(addOns.id == addOnId.id) {
            _addOnList.add(addOns);
            break;
          }
        }
      });
      _addOnsList.add(_addOnList);

      _availableList.add(DateConverter.isAvailable(cartModel.product.availableTimeStarts, cartModel.product.availableTimeEnds));

      for(int index=0; index<_addOnList.length; index++) {
        _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
      }
      _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
    });
    _subTotal = _itemPrice + _addOns;

    return _subTotal;
  }

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    if(_cartList.isNotEmpty && _cartList[0].variations == null) {
      _cartList = [];
      cartRepo.addToCartList(_cartList);
    }
    calculationCart();
  }

  void addToCart(CartModel cartModel, int index) {
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);

    }else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);
    calculationCart();

    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
    }
    cartRepo.addToCartList(_cartList);

    calculationCart();
    update();
  }

  void removeFromCart(int index) {
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    calculationCart();
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    calculationCart();
    update();
  }

  void clearCartList() {
    _cartList = [];
    cartRepo.addToCartList(_cartList);
    calculationCart();
    update();
  }


  int isExistInCart(int productID, int cartIndex) {
    for(int index=0; index<_cartList.length; index++) {
      if(_cartList[index].product.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }


  int getCartIndex (Product product) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product.id == product.id ) {
        if(_cartList[index].product.variations[0].multiSelect  != null){
          if(_cartList[index].product.variations[0].multiSelect == product.variations[0].multiSelect){
            return index;
          }
        }
        else{
          return index;
        }

      }
    }
    return null;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for(CartModel cartModel in _cartList) {
      if(cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    calculationCart();
    update();
  }


}
