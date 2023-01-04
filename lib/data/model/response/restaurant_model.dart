class RestaurantModel {
  int totalSize;
  String limit;
  int offset;
  List<Restaurant> restaurants;

  RestaurantModel({this.totalSize, this.limit, this.offset, this.restaurants});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  int id;
  String name;
  String phone;
  String email;
  String logo;
  String latitude;
  String longitude;
  String address;
  int zoneId;
  double minimumOrder;
  String currency;
  bool freeDelivery;
  String coverPhoto;
  bool delivery;
  bool takeAway;
  bool scheduleOrder;
  double avgRating;
  double tax;
  int ratingCount;
  int selfDeliverySystem;
  bool posSystem;
  int open;
  bool active;
  String deliveryTime;
  List<int> categoryIds;
  int veg;
  int nonVeg;
  Discount discount;
  List<Schedules> schedules;
  double minimumShippingCharge;
  double perKmShippingCharge;
  int vendorId;
  String restaurantModel;
  RestaurantSubscription restaurantSubscription;

  Restaurant(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.logo,
        this.latitude,
        this.longitude,
        this.address,
        this.zoneId,
        this.minimumOrder,
        this.currency,
        this.freeDelivery,
        this.coverPhoto,
        this.delivery,
        this.takeAway,
        this.scheduleOrder,
        this.avgRating,
        this.tax,
        this.ratingCount,
        this.selfDeliverySystem,
        this.posSystem,
        this.open,
        this.active,
        this.deliveryTime,
        this.categoryIds,
        this.veg,
        this.nonVeg,
        this.discount,
        this.schedules,
        this.minimumShippingCharge,
        this.perKmShippingCharge,
        this.vendorId,
        this.restaurantModel,
        this.restaurantSubscription,
      });

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'] != null ? json['logo'] : '';
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    zoneId = json['zone_id'];
    minimumOrder = json['minimum_order'] != null ? json['minimum_order'].toDouble() : 0;
    currency = json['currency'];
    freeDelivery = json['free_delivery'];
    coverPhoto = json['cover_photo'] != null ? json['cover_photo'] : '';
    delivery = json['delivery'];
    takeAway = json['take_away'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'] != null ? json['avg_rating'].toDouble() : null;
    tax = json['tax'] != null ? json['tax'].toDouble() : null;
    ratingCount = json['rating_count '];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    open = json['open'];
    active = json['active'];
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    categoryIds = json['category_ids'] != null ? json['category_ids'].cast<int>() : [];
    discount = json['discount'] != null ? new Discount.fromJson(json['discount']) : null;
    if (json['schedules'] != null) {
      schedules = <Schedules>[];
      json['schedules'].forEach((v) {
        schedules.add(new Schedules.fromJson(v));
      });
    }
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0.0;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0.0;
    vendorId = json['vendor_id'];
    restaurantModel = json['restaurant_model'];
    restaurantSubscription = json['restaurant_sub'] != null ? RestaurantSubscription.fromJson(json['restaurant_sub']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['minimum_order'] = this.minimumOrder;
    data['currency'] = this.currency;
    data['zone_id'] = this.zoneId;
    data['free_delivery'] = this.freeDelivery;
    data['cover_photo'] = this.coverPhoto;
    data['delivery'] = this.delivery;
    data['take_away'] = this.takeAway;
    data['schedule_order'] = this.scheduleOrder;
    data['avg_rating'] = this.avgRating;
    data['tax'] = this.tax;
    data['rating_count '] = this.ratingCount;
    data['self_delivery_system'] = this.selfDeliverySystem;
    data['pos_system'] = this.posSystem;
    data['open'] = this.open;
    data['active'] = this.active;
    data['veg'] = this.veg;
    data['non_veg'] = this.nonVeg;
    data['delivery_time'] = this.deliveryTime;
    data['category_ids'] = this.categoryIds;
    if (this.discount != null) {
      data['discount'] = this.discount.toJson();
    }
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
    data['vendor_id'] = this.vendorId;
    return data;
  }
}

class Discount {
  int id;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  double minPurchase;
  double maxDiscount;
  double discount;
  String discountType;
  int restaurantId;
  String createdAt;
  String updatedAt;

  Discount(
      {this.id,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.minPurchase,
        this.maxDiscount,
        this.discount,
        this.discountType,
        this.restaurantId,
        this.createdAt,
        this.updatedAt});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'] != null ? json['start_time'].substring(0, 5) : null;
    endTime = json['end_time'] != null ? json['end_time'].substring(0, 5) : null;
    minPurchase = json['min_purchase'].toDouble();
    maxDiscount = json['max_discount'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    restaurantId = json['restaurant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['min_purchase'] = this.minPurchase;
    data['max_discount'] = this.maxDiscount;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Schedules {
  int id;
  int restaurantId;
  int day;
  String openingTime;
  String closingTime;

  Schedules(
      {this.id,
        this.restaurantId,
        this.day,
        this.openingTime,
        this.closingTime});

  Schedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    day = json['day'];
    openingTime = json['opening_time'].substring(0, 5);
    closingTime = json['closing_time'].substring(0, 5);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['restaurant_id'] = this.restaurantId;
    data['day'] = this.day;
    data['opening_time'] = this.openingTime;
    data['closing_time'] = this.closingTime;
    return data;
  }
}

class RestaurantSubscription {
  int id;
  int packageId;
  int restaurantId;
  String expiryDate;
  String maxOrder;
  String maxProduct;
  int pos;
  int mobileApp;
  int chat;
  int review;
  int selfDelivery;
  int status;
  int totalPackageRenewed;
  String createdAt;
  String updatedAt;

  RestaurantSubscription(
      {this.id,
        this.packageId,
        this.restaurantId,
        this.expiryDate,
        this.maxOrder,
        this.maxProduct,
        this.pos,
        this.mobileApp,
        this.chat,
        this.review,
        this.selfDelivery,
        this.status,
        this.totalPackageRenewed,
        this.createdAt,
        this.updatedAt});

  RestaurantSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    restaurantId = json['restaurant_id'];
    expiryDate = json['expiry_date'];
    maxOrder = json['max_order'];
    maxProduct = json['max_product'];
    pos = json['pos'];
    mobileApp = json['mobile_app'];
    chat = (json['chat'] != null && json['chat'] != 'null') ? json['chat'] : 0;
    review = json['review'] != null ? json['review'] : 0;
    selfDelivery = json['self_delivery'];
    status = json['status'];
    totalPackageRenewed = json['total_package_renewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['restaurant_id'] = this.restaurantId;
    data['expiry_date'] = this.expiryDate;
    data['max_order'] = this.maxOrder;
    data['max_product'] = this.maxProduct;
    data['pos'] = this.pos;
    data['mobile_app'] = this.mobileApp;
    data['chat'] = this.chat;
    data['review'] = this.review;
    data['self_delivery'] = this.selfDelivery;
    data['status'] = this.status;
    data['total_package_renewed'] = this.totalPackageRenewed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}