import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneModel {
  int id;
  String name;
  Coordinates coordinates;
  int status;
  String createdAt;
  String updatedAt;
  String restaurantWiseTopic;
  String customerWiseTopic;
  String deliverymanWiseTopic;
  double minimumShippingCharge;
  double perKmShippingCharge;

  ZoneModel({this.id, this.name, this.coordinates, this.status, this.createdAt, this.updatedAt, this.restaurantWiseTopic, this.customerWiseTopic, this.deliverymanWiseTopic, this.minimumShippingCharge, this.perKmShippingCharge});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coordinates = json['coordinates'] != null ? new Coordinates.fromJson(json['coordinates']) : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restaurantWiseTopic = json['restaurant_wise_topic'];
    customerWiseTopic = json['customer_wise_topic'];
    deliverymanWiseTopic = json['deliveryman_wise_topic'];
    minimumShippingCharge = json['minimum_shipping_charge'] != null ? json['minimum_shipping_charge'].toDouble() : 0;
    perKmShippingCharge = json['per_km_shipping_charge'] != null ? json['per_km_shipping_charge'].toDouble() : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['restaurant_wise_topic'] = this.restaurantWiseTopic;
    data['customer_wise_topic'] = this.customerWiseTopic;
    data['deliveryman_wise_topic'] = this.deliverymanWiseTopic;
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
    return data;
  }
}

class Coordinates {
  String type;
  List<LatLng> coordinates;

  Coordinates({this.type, this.coordinates});

  Coordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'][0].forEach((v) {
        coordinates.add(LatLng(double.parse(v[0].toString()), double.parse(v[1].toString())));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
