class ConfigModel {
  String businessName;
  String logo;
  String address;
  String phone;
  String email;
  BaseUrls baseUrls;
  String currencySymbol;
  bool cashOnDelivery;
  bool digitalPayment;
  String termsAndConditions;
  String privacyPolicy;
  String aboutUs;
  String country;
  DefaultLocation defaultLocation;
  String appUrlAndroid;
  String appUrlIos;
  bool customerVerification;
  bool orderDeliveryVerification;
  String currencySymbolDirection;
  double appMinimumVersionAndroid;
  double appMinimumVersionIos;
  double perKmShippingCharge;
  double minimumShippingCharge;
  double freeDeliveryOver;
  bool demo;
  bool maintenanceMode;
  int popularFood;
  int popularRestaurant;
  int mostReviewedFoods;
  int newRestaurant;
  String orderConfirmationModel;
  bool showDmEarning;
  bool canceledByDeliveryman;
  bool canceledByRestaurant;
  String timeformat;
  bool toggleVegNonVeg;
  bool toggleDmRegistration;
  bool toggleRestaurantRegistration;
  List<SocialLogin> socialLogin;
  int scheduleOrderSlotDuration;
  int digitAfterDecimalPoint;
  int loyaltyPointExchangeRate;
  double loyaltyPointItemPurchasePoint;
  int loyaltyPointStatus;
  int minimumPointToTransfer;
  int customerWalletStatus;
  int dmTipsStatus;
  int refEarningStatus;
  double refEarningExchangeRate;
  int theme;
  BusinessPlan businessPlan;
  double adminCommission;
  bool refundStatus;
  int refundPolicyStatus;
  String refundPolicyData;
  int cancellationPolicyStatus;
  String cancellationPolicyData;
  int shippingPolicyStatus;
  String shippingPolicyData;
  int freeTrialPeriodStatus;
  int freeTrialPeriodDay;

  ConfigModel(
      {this.businessName,
        this.logo,
        this.address,
        this.phone,
        this.email,
        this.baseUrls,
        this.currencySymbol,
        this.cashOnDelivery,
        this.digitalPayment,
        this.termsAndConditions,
        this.privacyPolicy,
        this.aboutUs,
        this.country,
        this.defaultLocation,
        this.appUrlAndroid,
        this.appUrlIos,
        this.customerVerification,
        this.orderDeliveryVerification,
        this.currencySymbolDirection,
        this.appMinimumVersionAndroid,
        this.appMinimumVersionIos,
        this.perKmShippingCharge,
        this.minimumShippingCharge,
        this.freeDeliveryOver,
        this.demo,
        this.maintenanceMode,
        this.popularFood,
        this.popularRestaurant,
        this.mostReviewedFoods,
        this.newRestaurant,
        this.orderConfirmationModel,
        this.showDmEarning,
        this.canceledByDeliveryman,
        this.canceledByRestaurant,
        this.timeformat,
        this.toggleVegNonVeg,
        this.toggleDmRegistration,
        this.toggleRestaurantRegistration,
        this.socialLogin,
        this.scheduleOrderSlotDuration,
        this.digitAfterDecimalPoint,
        this.loyaltyPointExchangeRate,
        this.loyaltyPointItemPurchasePoint,
        this.loyaltyPointStatus,
        this.minimumPointToTransfer,
        this.customerWalletStatus,
        this.dmTipsStatus,
        this.refEarningStatus,
        this.refEarningExchangeRate,
        this.theme,
        this.businessPlan,
        this.adminCommission,
        this.refundStatus,
        this.refundPolicyStatus,
        this.refundPolicyData,
        this.cancellationPolicyStatus,
        this.cancellationPolicyData,
        this.shippingPolicyStatus,
        this.shippingPolicyData,
        this.freeTrialPeriodStatus,
        this.freeTrialPeriodDay,
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    baseUrls = json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;
    currencySymbol = json['currency_symbol'];
    cashOnDelivery = json['cash_on_delivery'];
    digitalPayment = json['digital_payment'];
    termsAndConditions = json['terms_and_conditions'];
    privacyPolicy = json['privacy_policy'];
    aboutUs = json['about_us'];
    country = json['country'];
    defaultLocation = json['default_location'] != null ? DefaultLocation.fromJson(json['default_location']) : null;
    appUrlAndroid = json['app_url_android'];
    appUrlIos = json['app_url_ios'];
    customerVerification = json['customer_verification'];
    orderDeliveryVerification = json['order_delivery_verification'];
    currencySymbolDirection = json['currency_symbol_direction'];
    appMinimumVersionAndroid = json['app_minimum_version_android'] != null ? json['app_minimum_version_android'].toDouble() : 0.0;
    appMinimumVersionIos = json['app_minimum_version_ios'] != null ? json['app_minimum_version_ios'].toDouble() : 0.0;
    perKmShippingCharge = json['per_km_shipping_charge'].toDouble();
    minimumShippingCharge = json['minimum_shipping_charge'].toDouble();
    freeDeliveryOver = json['free_delivery_over'] != null ? double.parse(json['free_delivery_over'].toString()) : null;
    demo = json['demo'];
    maintenanceMode = json['maintenance_mode'];
    popularFood = json['popular_food'];
    popularRestaurant = json['popular_restaurant'];
    newRestaurant = json['new_restaurant'];
    mostReviewedFoods = json['most_reviewed_foods'];
    orderConfirmationModel = json['order_confirmation_model'];
    showDmEarning = json['show_dm_earning'];
    canceledByDeliveryman = json['canceled_by_deliveryman'];
    canceledByRestaurant = json['canceled_by_restaurant'];
    timeformat = json['timeformat'];
    toggleVegNonVeg = json['toggle_veg_non_veg'];
    toggleDmRegistration = json['toggle_dm_registration'];
    toggleRestaurantRegistration = json['toggle_restaurant_registration'];
    if (json['social_login'] != null) {
      socialLogin = <SocialLogin>[];
      json['social_login'].forEach((v) {
        socialLogin.add(new SocialLogin.fromJson(v));
      });
    }
    scheduleOrderSlotDuration = json['schedule_order_slot_duration'] == 0 ? 30 : json['schedule_order_slot_duration'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
    loyaltyPointExchangeRate = json['loyalty_point_exchange_rate'];
    loyaltyPointItemPurchasePoint = json['loyalty_point_item_purchase_point'].toDouble();
    loyaltyPointStatus = json['loyalty_point_status'];
    minimumPointToTransfer = json['minimum_point_to_transfer'];
    customerWalletStatus = json['customer_wallet_status'];
    dmTipsStatus = json['dm_tips_status'];
    refEarningStatus = json['ref_earning_status'];
    refEarningExchangeRate = json['ref_earning_exchange_rate'].toDouble();
    theme = json['theme'];
    businessPlan = json['business_plan'] != null ? BusinessPlan.fromJson(json['business_plan']) : null;
    adminCommission = json['admin_commission'].toDouble();
    refundStatus = json['refund_active_status'];
    refundPolicyStatus = json['refund_policy_status'];
    refundPolicyData = json['refund_policy_data'];
    cancellationPolicyStatus = json['cancellation_policy_status'];
    cancellationPolicyData = json['cancellation_policy_data'];
    shippingPolicyStatus = json['shipping_policy_status'];
    shippingPolicyData = json['shipping_policy_data'];
    freeTrialPeriodStatus = json['free_trial_period_status'];
    freeTrialPeriodDay = json['free_trial_period_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    if (this.baseUrls != null) {
      data['base_urls'] = this.baseUrls.toJson();
    }
    data['currency_symbol'] = this.currencySymbol;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['digital_payment'] = this.digitalPayment;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    data['country'] = this.country;
    if (this.defaultLocation != null) {
      data['default_location'] = this.defaultLocation.toJson();
    }
    data['app_url_android'] = this.appUrlAndroid;
    data['app_url_ios'] = this.appUrlIos;
    data['customer_verification'] = this.customerVerification;
    data['order_delivery_verification'] = this.orderDeliveryVerification;
    data['currency_symbol_direction'] = this.currencySymbolDirection;
    data['app_minimum_version_android'] = this.appMinimumVersionAndroid;
    data['app_minimum_version_ios'] = this.appMinimumVersionIos;
    data['per_km_shipping_charge'] = this.perKmShippingCharge;
    data['minimum_shipping_charge'] = this.minimumShippingCharge;
    data['free_delivery_over'] = this.freeDeliveryOver;
    data['demo'] = this.demo;
    data['maintenance_mode'] = this.maintenanceMode;
    data['popular_food'] = this.popularFood;
    data['popular_restaurant'] = this.popularRestaurant;
    data['new_restaurant'] = this.newRestaurant;
    data['most_reviewed_foods'] = this.mostReviewedFoods;
    data['order_confirmation_model'] = this.orderConfirmationModel;
    data['show_dm_earning'] = this.showDmEarning;
    data['canceled_by_deliveryman'] = this.canceledByDeliveryman;
    data['canceled_by_restaurant'] = this.canceledByRestaurant;
    data['timeformat'] = this.timeformat;
    data['toggle_veg_non_veg'] = this.toggleVegNonVeg;
    data['toggle_dm_registration'] = this.toggleDmRegistration;
    data['toggle_restaurant_registration'] = this.toggleRestaurantRegistration;
    if (this.socialLogin != null) {
      data['social_login'] = this.socialLogin.map((v) => v.toJson()).toList();
    }
    data['schedule_order_slot_duration'] = this.scheduleOrderSlotDuration;
    data['digit_after_decimal_point'] = this.digitAfterDecimalPoint;
    data['loyalty_point_exchange_rate'] = this.loyaltyPointExchangeRate;
    data['loyalty_point_item_purchase_point'] = this.loyaltyPointItemPurchasePoint;
    data['loyalty_point_status'] = this.loyaltyPointStatus;
    data['minimum_point_to_transfer'] = this.minimumPointToTransfer;
    data['customer_wallet_status'] = this.customerWalletStatus;
    data['dm_tips_status'] = this.dmTipsStatus;
    data['ref_earning_status'] = this.refEarningStatus;
    data['ref_earning_exchange_rate'] = this.refEarningExchangeRate;
    data['theme'] = this.theme;
    data['refund_active_status'] = this.refundStatus;
    return data;
  }
}

class BaseUrls {
  String productImageUrl;
  String customerImageUrl;
  String bannerImageUrl;
  String categoryImageUrl;
  String reviewImageUrl;
  String notificationImageUrl;
  String restaurantImageUrl;
  String restaurantCoverPhotoUrl;
  String deliveryManImageUrl;
  String chatImageUrl;
  String campaignImageUrl;
  String businessLogoUrl;

  BaseUrls(
      {this.productImageUrl,
        this.customerImageUrl,
        this.bannerImageUrl,
        this.categoryImageUrl,
        this.reviewImageUrl,
        this.notificationImageUrl,
        this.restaurantImageUrl,
        this.restaurantCoverPhotoUrl,
        this.deliveryManImageUrl,
        this.chatImageUrl,
        this.campaignImageUrl,
        this.businessLogoUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    productImageUrl = json['product_image_url'];
    customerImageUrl = json['customer_image_url'];
    bannerImageUrl = json['banner_image_url'];
    categoryImageUrl = json['category_image_url'];
    reviewImageUrl = json['review_image_url'];
    notificationImageUrl = json['notification_image_url'];
    restaurantImageUrl = json['restaurant_image_url'];
    restaurantCoverPhotoUrl = json['restaurant_cover_photo_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    chatImageUrl = json['chat_image_url'];
    campaignImageUrl = json['campaign_image_url'];
    businessLogoUrl = json['business_logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this.productImageUrl;
    data['customer_image_url'] = this.customerImageUrl;
    data['banner_image_url'] = this.bannerImageUrl;
    data['category_image_url'] = this.categoryImageUrl;
    data['review_image_url'] = this.reviewImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['restaurant_image_url'] = this.restaurantImageUrl;
    data['restaurant_cover_photo_url'] = this.restaurantCoverPhotoUrl;
    data['delivery_man_image_url'] = this.deliveryManImageUrl;
    data['chat_image_url'] = this.chatImageUrl;
    data['campaign_image_url'] = this.campaignImageUrl;
    data['business_logo_url'] = this.businessLogoUrl;
    return data;
  }
}

class DefaultLocation {
  String lat;
  String lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class SocialLogin {
  String loginMedium;
  bool status;

  SocialLogin({this.loginMedium, this.status});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    loginMedium = json['login_medium'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_medium'] = this.loginMedium;
    data['status'] = this.status;
    return data;
  }
}

class BusinessPlan {
  int commission;
  int subscription;

  BusinessPlan({this.commission, this.subscription});

  BusinessPlan.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['subscription'] = this.subscription;
    return data;
  }
}
