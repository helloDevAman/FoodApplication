
enum NotificationType{
  message,
  order,
  general,
}

class NotificationBody {
  NotificationType notificationType;
  int orderId;
  int adminId;
  int deliverymanId;
  int restaurantId;
  String type;
  int conversationId;

  NotificationBody({
    this.notificationType,
    this.orderId,
    this.adminId,
    this.deliverymanId,
    this.restaurantId,
    this.type,
    this.conversationId,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    adminId = json['admin_id'];
    deliverymanId = json['deliveryman_id'];
    restaurantId = json['restaurant_id'];
    type = json['type'];
    conversationId = json['conversation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_notification'] = this.notificationType.toString();
    data['order_id'] = this.orderId;
    data['admin_id'] = this.adminId;
    data['deliveryman_id'] = this.deliverymanId;
    data['restaurant_id'] = this.restaurantId;
    data['type'] = this.type;
    data['conversation_id'] = this.conversationId;
    return data;
  }

  NotificationType convertToEnum(String enumString) {
    if(enumString == NotificationType.general.toString()) {
      return NotificationType.general;
    }else if(enumString == NotificationType.order.toString()) {
      return NotificationType.order;
    }else if(enumString == NotificationType.message.toString()) {
      return NotificationType.message;
    }
    return NotificationType.general;
  }

}
