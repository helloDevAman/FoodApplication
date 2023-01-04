import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:flutter/material.dart';

class PlaceOrderBody {
  List<Cart> _cart;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;
  int _restaurantId;
  double _distance;
  String _scheduleAt;
  double _discountAmount;
  double _taxAmount;
  String _address;
  String _latitude;
  String _longitude;
  String _contactPersonName;
  String _contactPersonNumber;
  String _addressType;
  String _road;
  String _house;
  String _floor;
  String _dmTips;

  PlaceOrderBody(
      {@required List<Cart> cart,
        @required double couponDiscountAmount,
        @required String couponDiscountTitle,
        @required String couponCode,
        @required double orderAmount,
        @required String orderType,
        @required String paymentMethod,
        @required int restaurantId,
        @required double distance,
        @required String scheduleAt,
        @required double discountAmount,
        @required double taxAmount,
        @required String orderNote,
        @required String address,
        @required String latitude,
        @required String longitude,
        @required String contactPersonName,
        @required String contactPersonNumber,
        @required String addressType,
        @required String road,
        @required String house,
        @required String floor,
        @required String dmTips,
      }) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._restaurantId = restaurantId;
    this._distance = distance;
    this._scheduleAt = scheduleAt;
    this._discountAmount = discountAmount;
    this._taxAmount = taxAmount;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._contactPersonName = contactPersonName;
    this._contactPersonNumber = contactPersonNumber;
    this._addressType = addressType;
    this._road = road;
    this._house = house;
    this._floor = floor;
    this._dmTips = dmTips;
  }

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  int get restaurantId => _restaurantId;
  double get distance => _distance;
  String get scheduleAt => _scheduleAt;
  double get discountAmount => _discountAmount;
  double get taxAmount => _taxAmount;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;
  String get road => _road;
  String get house => _house;
  String get floor => _floor;
  String get dmTips => _dmTips;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _restaurantId = json['restaurant_id'];
    _distance = json['distance'];
    _scheduleAt = json['schedule_at'];
    _discountAmount = json['discount_amount'].toDouble();
    _taxAmount = json['tax_amount'].toDouble();
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
    _road = json['road'];
    _house = json['house'];
    _floor = json['floor'];
    _dmTips = json['dm_tips'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['restaurant_id'] = this._restaurantId;
    data['distance'] = this._distance;
    data['schedule_at'] = this._scheduleAt;
    data['discount_amount'] = this._discountAmount;
    data['tax_amount'] = this._taxAmount;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['contact_person_name'] = this._contactPersonName;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address_type'] = this._addressType;
    data['road'] = this._road;
    data['house'] = this._house;
    data['floor'] = this._floor;
    data['dm_tips'] = this._dmTips;
    return data;
  }
}

class Cart {
  int _foodId;
  int _itemCampaignId;
  String _price;
  String _variant;
  List<OrderVariation> _variation;
  int _quantity;
  List<int> _addOnIds;
  List<AddOns> _addOns;
  List<int> _addOnQtys;

  Cart(
      int foodId,
      int itemCampaignId,
        String price,
        String variant,
        List<OrderVariation> variation,
        int quantity,
        List<int> addOnIds,
        List<AddOns> addOns,
        List<int> addOnQtys) {
    this._foodId = foodId;
    this._itemCampaignId = itemCampaignId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._quantity = quantity;
    this._addOnIds = addOnIds;
    this._addOns = addOns;
    this._addOnQtys = addOnQtys;
  }

  int get foodId => _foodId;
  int get itemCampaignId => _itemCampaignId;
  String get price => _price;
  String get variant => _variant;
  List<OrderVariation> get variation => _variation;
  int get quantity => _quantity;
  List<int> get addOnIds => _addOnIds;
  List<AddOns> get addOns => _addOns;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _foodId = json['food_id'];
    _itemCampaignId = json['item_campaign_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variations'].forEach((v) {
        _variation.add(new OrderVariation.fromJson(v));
      });
    }
    _quantity = json['quantity'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this._foodId;
    data['item_campaign_id'] = this._itemCampaignId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variations'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this._quantity;
    data['add_on_ids'] = this._addOnIds;
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}

class OrderVariation {
  String name;
  OrderVariationValue values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values =
    json['values'] != null ? new OrderVariationValue.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.values != null) {
      data['values'] = this.values.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String> label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    return data;
  }
}
