import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/body/review_body.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/repository/product_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  ProductController({@required this.productRepo});

  // Latest products
  List<Product> _popularProductList;
  List<Product> _reviewedProductList;
  bool _isLoading = false;
  List<List<bool>> _selectedVariations = [];
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  String _popularType = 'all';
  String _reviewedType = 'all';
  static List<String> _productTypeList = ['all', 'veg', 'non_veg'];
  int _cartIndex = -1;
  int _imageIndex = 0;

  List<Product> get popularProductList => _popularProductList;
  List<Product> get reviewedProductList => _reviewedProductList;
  bool get isLoading => _isLoading;
  List<List<bool>> get selectedVariations => _selectedVariations;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  String get popularType => _popularType;
  String get reviewType => _reviewedType;
  List<String> get productTypeList => _productTypeList;
  int get cartIndex => _cartIndex;
  int get imageIndex => _imageIndex;

  Future<void> getPopularProductList(bool reload, String type, bool notify) async {
    _popularType = type;
    if(reload) {
      _popularProductList = null;
    }
    if(notify) {
      update();
    }
    if(_popularProductList == null || reload) {
      Response response = await productRepo.getPopularProductList(type);
      if (response.statusCode == 200) {
        _popularProductList = [];
        _popularProductList.addAll(ProductModel.fromJson(response.body).products);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getReviewedProductList(bool reload, String type, bool notify) async {
    _reviewedType = type;
    if(reload) {
      _reviewedProductList = null;
    }
    if(notify) {
      update();
    }
    if(_reviewedProductList == null || reload) {
      Response response = await productRepo.getReviewedProductList(type);
      if (response.statusCode == 200) {
        _reviewedProductList = [];
        _reviewedProductList.addAll(ProductModel.fromJson(response.body).products);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void initData(Product product, CartModel cart) {
    _selectedVariations = [];
    _addOnQtyList = [];
    _addOnActiveList = [];

    if(cart != null) {
      _quantity = cart.quantity;
      _selectedVariations.addAll(cart.variations);
      List<int> _addOnIdList = [];
      cart.addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }else {
      _quantity = 1;
      if(product.variations != null){
        for(int index=0; index<product.variations.length; index++) {
          _selectedVariations.add([]);
          for(int i=0; i < product.variations[index].variationValues.length; i++) {
            _selectedVariations[index].add(false);
          }
        }
      }

      product.addOns.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });

    }
  }

  int selectedVariationLength(List<List<bool>> selectedVariations, int index) {
    int _length = 0;
    for(bool isSelected in selectedVariations[index]) {
      if(isSelected) {
        _length++;
      }
    }
    return _length;
  }

  int setExistInCart(Product product, {bool notify = true}) {
    // List<String> _variationList = [];
    // for (int index = 0; index < product.choiceOptions.length; index++) {
    //   // _variationList.add(product.choiceOptions[index].options[_variationIndex[index]].replaceAll(' ', ''));
    // }
    // String variationType = '';
    // bool isFirst = true;
    // _variationList.forEach((variation) {
    //   if (isFirst) {
    //     variationType = '$variationType$variation';
    //     isFirst = false;
    //   } else {
    //     variationType = '$variationType-$variation';
    //   }
    // });
    _cartIndex = Get.find<CartController>().isExistInCart(product.id, null);
    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int> _addOnIdList = [];
      Get.find<CartController>().cartList[_cartIndex].addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if(_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(Get.find<CartController>().cartList[_cartIndex].addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    }
    return _cartIndex;
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    update();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i, Product product, bool isMultiSelect) {
    if(!isMultiSelect) {
      for(int j = 0; j < _selectedVariations[index].length; j++) {
        if(product.variations[index].required){
          _selectedVariations[index][j] = j == i;
        }else{
          if(_selectedVariations[index][j]){
            _selectedVariations[index][j] = false;
          }else{
            _selectedVariations[index][j] = j == i;
          }
        }
      }
    } else {
      if(!_selectedVariations[index][i] && selectedVariationLength(_selectedVariations, index) >= product.variations[index].max) {
        _showUpperCartSnackBar('${'maximum_variation_for'.tr} ${product.variations[index].name} ${'is'.tr} ${product.variations[index].max}');
      }else {
        _selectedVariations[index][i] = !_selectedVariations[index][i];
      }
    }
    update();
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

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    update();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    update();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    update();

    Response response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _loadingList[index] = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    update();
    Response response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // double getStartingPrice(Product product) {
  //   double _startingPrice = 0;
  //   if (product.choiceOptions.length != 0) {
  //     List<double> _priceList = [];
  //     product.variations.forEach((variation) => _priceList.add(variation.price));
  //     _priceList.sort((a, b) => a.compareTo(b));
  //     _startingPrice = _priceList[0];
  //   } else {
  //     _startingPrice = product.price;
  //   }
  //   return _startingPrice;
  // }

  bool isAvailable(Product product) {
    return DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds);
  }

  double getDiscount(Product product) => product.restaurantDiscount == 0 ? product.discount : product.restaurantDiscount;

  String getDiscountType(Product product) => product.restaurantDiscount == 0 ? product.discountType : 'percent';

}
