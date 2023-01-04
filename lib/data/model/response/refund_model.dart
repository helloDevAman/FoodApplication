class RefundModel {
  List<RefundReasons> refundReasons;

  RefundModel({this.refundReasons});

  RefundModel.fromJson(Map<String, dynamic> json) {
    if (json['refund_reasons'] != null) {
      refundReasons = <RefundReasons>[];
      json['refund_reasons'].forEach((v) {
        refundReasons.add(new RefundReasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.refundReasons != null) {
      data['refund_reasons'] =
          this.refundReasons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RefundReasons {
  int id;
  String reason;
  int status;
  String createdAt;
  String updatedAt;

  RefundReasons(
      {this.id, this.reason, this.status, this.createdAt, this.updatedAt});

  RefundReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}