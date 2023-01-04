class ProductModel {
  int totalSize;
  String limit;
  int offset;
  List<Product> products;

  ProductModel( {
    this.totalSize ,
    this.limit ,
    this.offset ,
    this.products
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        if(v['variations'] == null || v['variations'].isEmpty || v['variations'][0]['values'] != null) {
          products.add(new Product.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String name;
  String description;
  String image;
  int categoryId;
  List<CategoryIds> categoryIds;
  List<Variation> variations;
  List<AddOns> addOns;
  List<ChoiceOptions> choiceOptions;
  double price;
  double tax;
  double discount;
  String discountType;
  String availableTimeStarts;
  String availableTimeEnds;
  int restaurantId;
  String restaurantName;
  double restaurantDiscount;
  bool scheduleOrder;
  double avgRating;
  int ratingCount;
  int veg;

  Product(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.categoryId,
        this.categoryIds,
        this.variations,
        this.addOns,
        this.choiceOptions,
        this.price,
        this.tax,
        this.discount,
        this.discountType,
        this.availableTimeStarts,
        this.availableTimeEnds,
        this.restaurantId,
        this.restaurantName,
        this.restaurantDiscount,
        this.scheduleOrder,
        this.avgRating,
        this.ratingCount,
        this.veg,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    if (json['variations'] != null && json['variations'].isNotEmpty) {
      variations = [];
      if(json['variations'][0]['values'] != null) {
        json['variations'].forEach((v) {
          variations.add(new Variation.fromJson(v));
        });
      }
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns.add(new AddOns.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    price = json['price'].toDouble();
    tax = json['tax'] != null ? json['tax'].toDouble() : null;
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount'].toDouble();
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    veg = json['veg'] != null ? int.parse(json['veg'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['variations'] = this.variations.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['available_time_starts'] = this.availableTimeStarts;
    data['available_time_ends'] = this.availableTimeEnds;
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_discount'] = this.restaurantDiscount;
    data['schedule_order'] = this.scheduleOrder;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['veg'] = this.veg;
    return data;
  }
}

class CategoryIds {
  String id;

  CategoryIds({this.id});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Variation {
  String name;
  bool multiSelect;
  int min;
  int max;
  bool required;
  List<VariationValue> variationValues;

  Variation({this.name, this.multiSelect, this.min, this.max, this.required, this.variationValues});

  Variation.fromJson(Map<String, dynamic> json) {
    if(json['max'] != null) {
      name = json['name'];
      multiSelect = json['type'] == 'multi';
      min =  multiSelect ? int.parse(json['min'].toString()) : 0;
      max = multiSelect ? int.parse(json['max'].toString()) : 0;
      required = json['required'] == 'on';
      if (json['values'] != null) {
        variationValues = [];
        json['values'].forEach((v) {
          variationValues.add(new VariationValue.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.multiSelect;
    data['min'] = this.min;
    data['max'] = this.max;
    data['required'] = this.required;
    if (this.variationValues != null) {
      data['values'] = this.variationValues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationValue {
  String level;
  double optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.level;
    data['optionPrice'] = this.optionPrice;
    return data;
  }
}

class AddOns {
  int id;
  String name;
  double price;

  AddOns(
      {this.id,
        this.name,
        this.price});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class ChoiceOptions {
  String name;
  String title;
  List<String> options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}
