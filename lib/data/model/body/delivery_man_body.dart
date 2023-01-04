class DeliveryManBody {
  String fName;
  String lName;
  String phone;
  String email;
  String password;
  String identityType;
  String identityNumber;
  String earning;
  String zoneId;

  DeliveryManBody(
      {this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.identityType,
        this.identityNumber,
        this.earning,
        this.zoneId,
      });

  DeliveryManBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    identityType = json['identity_type'];
    identityNumber = json['identity_number'];
    earning = json['earning'];
    zoneId = json['zone_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['identity_type'] = this.identityType;
    data['identity_number'] = this.identityNumber;
    data['earning'] = this.earning;
    data['zone_id'] = this.zoneId;
    return data;
  }
}
