import 'package:efood_multivendor/data/model/response/conversation_model.dart';

class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  String phone;
  String password;
  int orderCount;
  int memberSinceDays;
  double walletBalance;
  int loyaltyPoint;
  String refCode;
  String socialId;
  User userInfo;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.phone,
        this.password,
        this.orderCount,
        this.memberSinceDays,
        this.walletBalance,
        this.loyaltyPoint,
        this.refCode,
        this.socialId,
        this.userInfo,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    password = json['password'];
    orderCount = json['order_count'];
    memberSinceDays = json['member_since_days'];
    walletBalance = json['wallet_balance'].toDouble();
    loyaltyPoint = json['loyalty_point'];
    refCode = json['ref_code'];
    socialId = json['social_id'] != null ? json['social_id'] : null;
    userInfo = json['userinfo'] != null ? new User.fromJson(json['userinfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['order_count'] = this.orderCount;
    data['member_since_days'] = this.memberSinceDays;
    data['wallet_balance'] = this.walletBalance;
    data['loyalty_point'] = this.loyaltyPoint;
    data['ref_code'] = this.refCode;
    if (this.userInfo != null) {
      data['user`info'] = this.userInfo.toJson();
    }
    return data;
  }
}
