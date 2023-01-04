import 'package:efood_multivendor/data/model/response/restaurant_model.dart';

class BasicCampaignModel {
  int id;
  String title;
  String image;
  String description;
  String availableDateStarts;
  String availableDateEnds;
  String startTime;
  String endTime;
  List<Restaurant> restaurants;

  BasicCampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.availableDateStarts,
        this.availableDateEnds,
        this.startTime,
        this.endTime,
        this.restaurants});

  BasicCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['restaurants'] != null) {
      restaurants = [];
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['available_date_starts'] = this.availableDateStarts;
    data['available_date_ends'] = this.availableDateEnds;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
