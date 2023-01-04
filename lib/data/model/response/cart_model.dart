import 'package:efood_multivendor/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _discountedPrice;
  List<List<bool>> _variations;
  double _discountAmount;
  int _quantity;
  List<AddOn> _addOnIds;
  List<AddOns> _addOns;
  bool _isCampaign;
  Product _product;

  CartModel(
        double price,
        double discountedPrice,
        double discountAmount,
        int quantity,
        List<AddOn> addOnIds,
        List<AddOns> addOns,
        bool isCampaign,
        Product product,
      List<List<bool>> variations) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._addOnIds = addOnIds;
    this._addOns = addOns;
    this._isCampaign = isCampaign;
    this._product = product;
    this._variations = variations;
  }

  double get price => _price;
  double get discountedPrice => _discountedPrice;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  List<AddOn> get addOnIds => _addOnIds;
  List<AddOns> get addOns => _addOns;
  bool get isCampaign => _isCampaign;
  Product get product => _product;
  List<List<bool>> get variations => _variations;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _isCampaign = json['is_campaign'];
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
    if (json['variations'] != null) {
      _variations = [];
      for(int index=0; index<json['variations'].length; index++) {
        _variations.add([]);
        for(int i=0; i<json['variations'][index].length; i++) {
          _variations[index].add(json['variations'][index][i]);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    if (this._addOnIds != null) {
      data['add_on_ids'] = this._addOnIds.map((v) => v.toJson()).toList();
    }
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = this._isCampaign;
    data['product'] = this._product.toJson();
    data['variations'] = this._variations;
    return data;
  }
}

class AddOn {
  int _id;
  int _quantity;

  AddOn({int id, int quantity}) {
    this._id = id;
    this._quantity = quantity;
  }

  int get id => _id;
  int get quantity => _quantity;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['quantity'] = this._quantity;
    return data;
  }
}
