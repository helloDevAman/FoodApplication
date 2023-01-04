class RestaurantBody {
  String restaurantName;
  String restaurantAddress;
  String vat;
  String minDeliveryTime;
  String maxDeliveryTime;
  String lat;
  String lng;
  String fName;
  String lName;
  String phone;
  String email;
  String password;
  String zoneId;

  RestaurantBody(
      {this.restaurantName,
        this.restaurantAddress,
        this.vat,
        this.minDeliveryTime,
        this.maxDeliveryTime,
        this.lat,
        this.lng,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.zoneId,
      });

  RestaurantBody.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurant_name'];
    restaurantAddress = json['restaurant_address'];
    vat = json['vat'];
    minDeliveryTime = json['min_delivery_time'];
    maxDeliveryTime = json['max_delivery_time'];
    lat = json['lat'];
    lng = json['lng'];
    fName = json['fName'];
    lName = json['lName'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    zoneId = json['zone_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_address'] = this.restaurantAddress;
    data['vat'] = this.vat;
    data['min_delivery_time'] = this.minDeliveryTime;
    data['max_delivery_time'] = this.maxDeliveryTime;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['fName'] = this.fName;
    data['lName'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['zone_id'] = this.zoneId;
    return data;
  }
}
