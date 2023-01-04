import 'package:efood_multivendor/data/model/response/product_model.dart';

class OrderDetailsModel {
  int id;
  int foodId;
  int orderId;
  double price;
  Product foodDetails;
  List<Variation> variation;
  List<OldVariation> oldVariation;
  List<AddOn> addOns;
  double discountOnFood;
  String discountType;
  int quantity;
  double taxAmount;
  String variant;
  String createdAt;
  String updatedAt;
  int itemCampaignId;
  double totalAddOnPrice;

  OrderDetailsModel(
      {this.id,
        this.foodId,
        this.orderId,
        this.price,
        this.foodDetails,
        this.variation,
        this.oldVariation,
        this.addOns,
        this.discountOnFood,
        this.discountType,
        this.quantity,
        this.taxAmount,
        this.variant,
        this.createdAt,
        this.updatedAt,
        this.itemCampaignId,
        this.totalAddOnPrice});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    price = json['price'].toDouble();
    foodDetails = json['food_details'] != null ? new Product.fromJson(json['food_details']) : null;
    variation = [];
    oldVariation = [];
    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if(json['variation'][0]['values'] != null) {
        json['variation'].forEach((v) {
          variation.add(new Variation.fromJson(v));
        });
      }else {
        json['variation'].forEach((v) {
          oldVariation.add(new OldVariation.fromJson(v));
        });
      }
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns.add(new AddOn.fromJson(v));
      });
    }
    discountOnFood = json['discount_on_food'].toDouble();
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemCampaignId = json['item_campaign_id'];
    totalAddOnPrice = json['total_add_on_price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['food_id'] = this.foodId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    if (this.foodDetails != null) {
      data['food_details'] = this.foodDetails.toJson();
    }
    if (this.variation != null) {
      data['variation'] = this.variation.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    data['discount_on_food'] = this.discountOnFood;
    data['discount_type'] = this.discountType;
    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['variant'] = this.variant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_campaign_id'] = this.itemCampaignId;
    data['total_add_on_price'] = this.totalAddOnPrice;
    return data;
  }
}

class AddOn {
  String name;
  double price;
  int quantity;

  AddOn({this.name, this.price, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'].toDouble();
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }
}

class OldVariation {
  String type;
  double price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}