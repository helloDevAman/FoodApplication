import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';

class PaginatedOrderModel {
  int totalSize;
  String limit;
  String offset;
  List<OrderModel> orders;

  PaginatedOrderModel({this.totalSize, this.limit, this.offset, this.orders});

  PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = json['offset'].toString();
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders.add(new OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class OrderModel {
  int id;
  int userId;
  double orderAmount;
  double couponDiscountAmount;
  String couponDiscountTitle;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  String paymentMethod;
  String couponCode;
  String orderNote;
  String orderType;
  String createdAt;
  String updatedAt;
  double deliveryCharge;
  String scheduleAt;
  String otp;
  String pending;
  String accepted;
  String confirmed;
  String processing;
  String handover;
  String pickedUp;
  String delivered;
  String canceled;
  String refundRequested;
  String refunded;
  int scheduled;
  double restaurantDiscountAmount;
  String failed;
  int detailsCount;
  double dmTips;
  int processingTime;
  DeliveryMan deliveryMan;
  Restaurant restaurant;
  AddressModel deliveryAddress;

  OrderModel(
      {this.id,
        this.userId,
        this.orderAmount,
        this.couponDiscountAmount,
        this.couponDiscountTitle,
        this.paymentStatus,
        this.orderStatus,
        this.totalTaxAmount,
        this.paymentMethod,
        this.couponCode,
        this.orderNote,
        this.orderType,
        this.createdAt,
        this.updatedAt,
        this.deliveryCharge,
        this.scheduleAt,
        this.otp,
        this.pending,
        this.accepted,
        this.confirmed,
        this.processing,
        this.handover,
        this.pickedUp,
        this.delivered,
        this.canceled,
        this.refundRequested,
        this.refunded,
        this.scheduled,
        this.restaurantDiscountAmount,
        this.failed,
        this.dmTips,
        this.processingTime,
        this.detailsCount,
        this.deliveryMan,
        this.deliveryAddress,
        this.restaurant,
      });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = json['order_amount'].toDouble();
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'].toDouble();
    paymentMethod = json['payment_method'];
    couponCode = json['coupon_code'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'].toDouble();
    scheduleAt = json['schedule_at'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    scheduled = json['scheduled'];
    dmTips = json['dm_tips'].toDouble();
    restaurantDiscountAmount = json['restaurant_discount_amount'].toDouble();
    failed = json['failed'];
    detailsCount = json['details_count'];
    processingTime = json['processing_time'];
    deliveryMan = json['delivery_man'] != null
        ? new DeliveryMan.fromJson(json['delivery_man'])
        : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    deliveryAddress = json['delivery_address'] != null
        ? new AddressModel.fromJson(json['delivery_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_amount'] = this.orderAmount;
    data['coupon_discount_amount'] = this.couponDiscountAmount;
    data['coupon_discount_title'] = this.couponDiscountTitle;
    data['payment_status'] = this.paymentStatus;
    data['order_status'] = this.orderStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['payment_method'] = this.paymentMethod;
    data['coupon_code'] = this.couponCode;
    data['order_note'] = this.orderNote;
    data['order_type'] = this.orderType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['schedule_at'] = this.scheduleAt;
    data['otp'] = this.otp;
    data['pending'] = this.pending;
    data['accepted'] = this.accepted;
    data['confirmed'] = this.confirmed;
    data['processing'] = this.processing;
    data['handover'] = this.handover;
    data['picked_up'] = this.pickedUp;
    data['delivered'] = this.delivered;
    data['canceled'] = this.canceled;
    data['refund_requested'] = this.refundRequested;
    data['refunded'] = this.refunded;
    data['scheduled'] = this.scheduled;
    data['restaurant_discount_amount'] = this.restaurantDiscountAmount;
    data['failed'] = this.failed;
    data['dm_tips'] = this.dmTips;
    data['processing_time'] = this.processingTime;
    data['details_count'] = this.detailsCount;
    if (this.deliveryMan != null) {
      data['delivery_man'] = this.deliveryMan.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    if (this.deliveryAddress != null) {
      data['delivery_address'] = this.deliveryAddress.toJson();
    }
    return data;
  }
}

class DeliveryMan {
  int id;
  String fName;
  String lName;
  String phone;
  String email;
  String image;
  int zoneId;
  int active;
  int available;
  double avgRating;
  int ratingCount;
  String lat;
  String lng;
  String location;

  DeliveryMan(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.image,
        this.zoneId,
        this.active,
        this.available,
        this.avgRating,
        this.ratingCount,
        this.lat,
        this.lng,
        this.location
      });

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    zoneId = json['zone_id'];
    active = json['active'];
    available = json['available'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['zone_id'] = this.zoneId;
    data['active'] = this.active;
    data['available'] = this.available;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    return data;
  }
}
