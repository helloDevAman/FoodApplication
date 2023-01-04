import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/response/notification_model.dart';
import 'package:efood_multivendor/data/repository/notification_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({@required this.notificationRepo});

  List<NotificationModel> _notificationList;
  bool _hasNotification = false;
  List<NotificationModel> get notificationList => _notificationList;
  bool get hasNotification => _hasNotification;

  Future<int> getNotificationList(bool reload) async {
    if(_notificationList == null || reload) {
      Response response = await notificationRepo.getNotificationList();
      if (response.statusCode == 200) {
        _notificationList = [];
        response.body.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
        _notificationList.sort((a, b) {
          return DateConverter.isoStringToLocalDate(a.updatedAt).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt));
        });
        Iterable iterable = _notificationList.reversed;
        _notificationList = iterable.toList();
        _hasNotification = _notificationList.length != getSeenNotificationCount();
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
    return _notificationList.length;
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }

}
