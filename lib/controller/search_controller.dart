import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/repository/search_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  SearchController({@required this.searchRepo});

  List<Product> _searchProductList;
  List<Product> _allProductList;
  List<Product> _suggestedFoodList;
  List<Restaurant> _searchRestList;
  List<Restaurant> _allRestList;
  String _searchText = '';
  String _restResultText = '';
  String _prodResultText = '';
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearchMode = true;
  List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  int _sortIndex = -1;
  int _rating = -1;
  bool _isRestaurant = false;
  bool _isAvailableFoods = false;
  bool _isDiscountedFoods = false;
  bool _veg = false;
  bool _nonVeg = false;

  List<Product> get searchProductList => _searchProductList;
  List<Product> get allProductList => _allProductList;
  List<Product> get suggestedFoodList => _suggestedFoodList;
  List<Restaurant> get searchRestList => _searchRestList;
  String get searchText => _searchText;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;
  bool get isSearchMode => _isSearchMode;
  List<String> get historyList => _historyList;
  List<String> get sortList => _sortList;
  int get sortIndex => _sortIndex;
  int get rating => _rating;
  bool get isRestaurant => _isRestaurant;
  bool get isAvailableFoods => _isAvailableFoods;
  bool get isDiscountedFoods => _isDiscountedFoods;
  bool get veg => _veg;
  bool get nonVeg => _nonVeg;

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleAvailableFoods() {
    _isAvailableFoods = !_isAvailableFoods;
    update();
  }

  void toggleDiscountedFoods() {
    _isDiscountedFoods = !_isDiscountedFoods;
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isRestaurant = isRestaurant;
    update();
  }

  void setSearchMode(bool isSearchMode) {
    _isSearchMode = isSearchMode;
    if(isSearchMode) {
      _searchText = '';
      _prodResultText = '';
      _restResultText = '';
      _allRestList = null;
      _allProductList = null;
      _searchProductList = null;
      _searchRestList = null;
      _sortIndex = -1;
      _isDiscountedFoods = false;
      _isAvailableFoods = false;
      _veg = false;
      _nonVeg = false;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }

  void sortFoodSearchList() {
    _searchProductList= [];
    _searchProductList.addAll(_allProductList);
    if(_upperValue > 0) {
      _searchProductList.removeWhere((product) => (product.price) <= _lowerValue || (product.price) > _upperValue);
    }
    if(_rating != -1) {
      _searchProductList.removeWhere((product) => product.avgRating < _rating);
    }
    if(!_veg && _nonVeg) {
      _searchProductList.removeWhere((product) => product.veg == 1);
    }
    if(!_nonVeg && _veg) {
      _searchProductList.removeWhere((product) => product.veg == 0);
    }
    if(_isAvailableFoods || _isDiscountedFoods) {
      if(_isAvailableFoods) {
        _searchProductList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(_isDiscountedFoods) {
        _searchProductList.removeWhere((product) => product.discount == 0);
      }
    }
    if(_sortIndex != -1) {
      if(_sortIndex == 0) {
        _searchProductList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }else {
        _searchProductList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        Iterable iterable = _searchProductList.reversed;
        _searchProductList = iterable.toList();
      }
    }
    update();
  }

  void sortRestSearchList() {
    _searchRestList = [];
    _searchRestList.addAll(_allRestList);
    if(_rating != -1) {
      _searchRestList.removeWhere((restaurant) => restaurant.avgRating < _rating);
    }
    if(!_veg && _nonVeg) {
      _searchRestList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!_nonVeg && _veg) {
      _searchRestList.removeWhere((product) => product.veg == 0);
    }
    if(_isAvailableFoods || _isDiscountedFoods) {
      if(_isAvailableFoods) {
        _searchRestList.removeWhere((restaurant) => restaurant.open == 0);
      }
      if(_isDiscountedFoods) {
        _searchRestList.removeWhere((restaurant) => restaurant.discount == null);
      }
    }
    if(_sortIndex != -1) {
      if(_sortIndex == 0) {
        _searchRestList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }else {
        _searchRestList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        Iterable iterable = _searchRestList.reversed;
        _searchRestList = iterable.toList();
      }
    }
    update();
  }

  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  void getSuggestedFoods() async {
    Response response = await searchRepo.getSuggestedFoods();
    if(response.statusCode == 200) {
      _suggestedFoodList = [];
      response.body.forEach((suggestedFood) => _suggestedFoodList.add(Product.fromJson(suggestedFood)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void searchData(String query) async {
    if((_isRestaurant && query.isNotEmpty && query != _restResultText) || (!_isRestaurant && query.isNotEmpty && query != _prodResultText)) {
      _searchText = query;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
      if (_isRestaurant) {
        _searchRestList = null;
        _allRestList = null;
      } else {
        _searchProductList = null;
        _allProductList = null;
      }
      if (!_historyList.contains(query)) {
        _historyList.insert(0, query);
      }
      searchRepo.saveSearchHistory(_historyList);
      _isSearchMode = false;
      update();

      Response response = await searchRepo.getSearchData(query, _isRestaurant);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isRestaurant) {
            _searchRestList = [];
          } else {
            _searchProductList = [];
          }
        } else {
          if (_isRestaurant) {
            _restResultText = query;
            _searchRestList = [];
            _allRestList = [];
            _searchRestList.addAll(RestaurantModel.fromJson(response.body).restaurants);
            _allRestList.addAll(RestaurantModel.fromJson(response.body).restaurants);
          } else {
            _prodResultText = query;
            _searchProductList = [];
            _allProductList = [];
            _searchProductList.addAll(ProductModel.fromJson(response.body).products);
            _allProductList.addAll(ProductModel.fromJson(response.body).products);
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void getHistoryList() {
    _searchText = '';
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
    searchRepo.saveSearchHistory(_historyList);
    update();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  }

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableFoods = false;
    _isDiscountedFoods = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    update();
  }

}
