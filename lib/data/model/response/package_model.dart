
class PackageModel {
  List<Packages> packages;

  PackageModel({this.packages});

  PackageModel.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) { packages.add(new Packages.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.packages != null) {
      data['packages'] = this.packages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  int id;
  String packageName;
  double price;
  int validity;
  String maxOrder;
  String maxProduct;
  int pos;
  int mobileApp;
  int chat;
  int review;
  int selfDelivery;
  int status;
  int def;
  String createdAt;
  String updatedAt;
  String color;

  Packages({this.id, this.packageName, this.price, this.validity, this.maxOrder, this.maxProduct, this.pos, this.mobileApp, this.chat, this.review, this.selfDelivery, this.status, this.def, this.createdAt, this.updatedAt, this.color});

Packages.fromJson(Map<String, dynamic> json) {
id = json['id'];
packageName = json['package_name'];
price = json['price'].toDouble();
validity = json['validity'];
maxOrder = json['max_order'];
maxProduct = json['max_product'];
pos = json['pos'];
mobileApp = json['mobile_app'];
chat = json['chat'];
review = json['review'];
selfDelivery = json['self_delivery'];
status = json['status'];
def = json['default'];
createdAt = json['created_at'];
updatedAt = json['updated_at'];
color = json['colour'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['package_name'] = this.packageName;
  data['price'] = this.price;
  data['validity'] = this.validity;
  data['max_order'] = this.maxOrder;
  data['max_product'] = this.maxProduct;
  data['pos'] = this.pos;
  data['mobile_app'] = this.mobileApp;
  data['chat'] = this.chat;
  data['review'] = this.review;
  data['self_delivery'] = this.selfDelivery;
  data['status'] = this.status;
  data['default'] = this.def;
  data['created_at'] = this.createdAt;
  data['updated_at'] = this.updatedAt;
  data['colour'] = this.color;
  return data;
}
}
