import 'dart:async';

import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/data/model/response/distance_model.dart';
import 'package:efood_multivendor/data/model/response/order_details_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/refund_model.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/model/response/timeslote_model.dart';
import 'package:efood_multivendor/data/repository/order_repo.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  bool _isLoading = false;
  bool _showCancelled = false;
  String _orderType = 'delivery';
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  List<int> _slotIndexList;
  int _selectedDateSlot = 0;
  int _selectedTimeSlot = 0;
  int _selectedTips = -1;
  double _distance;
  bool _runningPaginate = false;
  int _runningPageSize;
  List<int> _runningOffsetList = [];
  int _runningOffset = 1;
  bool _historyPaginate = false;
  int _historyPageSize;
  List<int> _historyOffsetList = [];
  int _historyOffset = 1;
  int _addressIndex = 0;
  double _tips = 0.0;
  bool _isRunningOrderViewShow = true;
  int _runningOrderIndex = 0;
  int _deliverySelectIndex = 0;
  Timer _timer;
  List<String> _refundReasons;
  int _selectedReasonIndex = 0;
  XFile _refundImage;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  String get orderType => _orderType;
  List<TimeSlotModel> get timeSlots => _timeSlots;
  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  List<int> get slotIndexList => _slotIndexList;
  int get selectedDateSlot => _selectedDateSlot;
  int get selectedTimeSlot => _selectedTimeSlot;
  int get selectedTips => _selectedTips;
  double get distance => _distance;
  bool get runningPaginate => _runningPaginate;
  int get runningPageSize => _runningPageSize;
  int get runningOffset => _runningOffset;
  bool get historyPaginate => _historyPaginate;
  int get historyPageSize => _historyPageSize;
  int get historyOffset => _historyOffset;
  int get addressIndex => _addressIndex;
  double get tips => _tips;
  bool get isRunningOrderViewShow => _isRunningOrderViewShow;
  int get runningOrderIndex => _runningOrderIndex;
  int get deliverySelectIndex => _deliverySelectIndex;
  int get selectedReasonIndex => _selectedReasonIndex;
  XFile get refundImage => _refundImage;
  List<String> get refundReasons => _refundReasons;

  void callTrackOrderApi({@required OrderModel orderModel, @required String orderId}){
    if(orderModel.orderStatus != 'delivered' && orderModel.orderStatus != 'failed' && orderModel.orderStatus != 'canceled') {
      print('start api call------------');

      Get.find<OrderController>().timerTrackOrder(orderId.toString());
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        Get.find<OrderController>().timerTrackOrder(orderId.toString());
      });
    }else{
      Get.find<OrderController>().timerTrackOrder(orderId.toString());
    }
  }

  void selectReason(int index,{bool isUpdate = true}){
    _selectedReasonIndex = index;
    if(isUpdate) {
      update();
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void selectDelivery(int index){
    _deliverySelectIndex = index;
    update();
  }


  void closeRunningOrder(bool isUpdate){
    _isRunningOrderViewShow = !_isRunningOrderViewShow;
    if(isUpdate){
      update();
    }
  }

  void addTips(double tips, {bool notify = true}) {
    _tips = tips;
    if(notify) {
      update();
    }
  }

  void pickRefundImage(bool isRemove) async {
    if(isRemove) {
      _refundImage = null;
    }else {
      _refundImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      update();
    }
  }

  Future<void> getRefundReasons()async {
    Response response = await orderRepo.getRefundReasons();
    if (response.statusCode == 200) {
      RefundModel _refundModel = RefundModel.fromJson(response.body);
      _refundReasons = [];
      _refundReasons.insert(0, 'select_an_option');
      _refundModel.refundReasons.forEach((element) {
        _refundReasons.add(element.reason);
      });
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> submitRefundRequest(String note, String orderId)async {
    if(_selectedReasonIndex == 0){
      showCustomSnackBar('please_select_reason'.tr);
    }else{
      _isLoading = true;
      update();
      Map<String, String> _body = Map();
      _body.addAll(<String, String>{
        'customer_reason': _refundReasons[selectedReasonIndex],
        'order_id': orderId,
        'customer_note': note,
      });
      Response response = await orderRepo.submitRefundRequest(_body, _refundImage);
      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        Get.offAllNamed(RouteHelper.getInitialRoute());
      }else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
  }

  Future<void> getRunningOrders(int offset, {bool notify = true, bool fromHome = false}) async {
    if(offset == 1) {
      _runningOffsetList = [];
      _runningOffset = 1;
      _runningOrderList = null;
      if(notify) {
        update();
      }
    }
    if (!_runningOffsetList.contains(offset)) {
      _runningOffsetList.add(offset);
      Response response = await orderRepo.getRunningOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _runningOrderList = [];
        }
        _runningOrderList.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _runningPageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _runningPaginate = false;
        if(fromHome && _isRunningOrderViewShow){
          canActiveOrder();
        }
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_runningPaginate) {
        _runningPaginate = false;
        update();
      }
    }
  }

  void canActiveOrder(){
    if(_runningOrderList.isNotEmpty){

      for(int i = 0; i < _runningOrderList.length; i++){
        if(_runningOrderList[i].orderStatus == AppConstants.PENDING || _runningOrderList[i].orderStatus == AppConstants.ACCEPTED
            || _runningOrderList[i].orderStatus == AppConstants.PROCESSING || _runningOrderList[i].orderStatus == AppConstants.CONFIRMED
            || _runningOrderList[i].orderStatus == AppConstants.HANDOVER || _runningOrderList[i].orderStatus == AppConstants.PICKED_UP){

          _isRunningOrderViewShow = true;
          _runningOrderIndex = i;
          print(_runningOrderIndex);
          break;
        }else{
          _isRunningOrderViewShow = false;
          print('not found any ongoing order');
        }
      }
      update();
    }
  }

  Future<void> getHistoryOrders(int offset, {bool notify = true}) async {
    if(offset == 1) {
      _historyOffsetList = [];
      _historyOrderList = null;
      if(notify) {
        update();
      }
    }
    _historyOffset = offset;
    if (!_historyOffsetList.contains(offset)) {
      _historyOffsetList.add(offset);
      Response response = await orderRepo.getHistoryOrderList(offset);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList.addAll(PaginatedOrderModel.fromJson(response.body).orders);
        _historyPageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _historyPaginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_historyPaginate) {
        _historyPaginate = false;
        update();
      }
    }
  }

  void showBottomLoader(bool isRunning) {
    if(isRunning) {
      _runningPaginate = true;
    }else {
      _historyPaginate = true;
    }
    update();
  }

  void setOffset(int offset, bool isRunning) {
    if(isRunning) {
      _runningOffset = offset;
    }else {
      _historyOffset = offset;
    }
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    Response response = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (response.statusCode == 200) {
      _orderDetails = [];
      response.body.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return _orderDetails;
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    update();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, bool fromTracking) async {
    print(orderModel == null);
    _trackModel = null;
    _responseModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      Response response = await orderRepo.trackOrder(orderID);
      if (response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(response.body);
        _responseModel = ResponseModel(true, response.body.toString());
        // callTrackOrderApi(orderModel: _trackModel, orderId: orderID);
      } else {
        _responseModel = ResponseModel(false, response.statusText);
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
      // callTrackOrderApi(orderModel: _trackModel, orderId: orderID);
    }
    return _responseModel;
  }

  Future<ResponseModel> timerTrackOrder(String orderID) async {
    _showCancelled = false;

    Response response = await orderRepo.trackOrder(orderID);
    if (response.statusCode == 200) {
      _trackModel = OrderModel.fromJson(response.body);
      _responseModel = ResponseModel(true, response.body.toString());
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      ApiChecker.checkApi(response);
    }
    update();

    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback, double amount) async {
    _isLoading = true;
    update();
    print('order body: ${placeOrderBody.toJson()}');
    Response response = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body['message'];
      String orderID = response.body['order_id'].toString();
      callback(true, message, orderID, amount);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, response.statusText, '-1', amount);
    }
    update();
  }

  void stopLoader() {
    _isLoading = false;
    update();
  }

  void clearPrevData() {
    _addressIndex = 0;
    _paymentMethodIndex = Get.find<SplashController>().configModel.cashOnDelivery ? 0
        : Get.find<SplashController>().configModel.digitalPayment ? 1
        : Get.find<SplashController>().configModel.customerWalletStatus == 1 ? 2 : 0;
    _selectedDateSlot = 0;
    _selectedTimeSlot = 0;
    _distance = null;
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    update();
  }

  void cancelOrder(int orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrder(orderID.toString());
    _isLoading = false;
    Get.back();
    if (response.statusCode == 200) {
      OrderModel orderModel;
      for(OrderModel order in _runningOrderList) {
        if(order.id == orderID) {
          orderModel = order;
          break;
        }
      }
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      print(response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      update();
    }
  }

  Future<void> initializeTimeSlot(Restaurant restaurant) async {
    _timeSlots = [];
    _allTimeSlots = [];
    int _minutes = 0;
    DateTime _now = DateTime.now();
    for(int index=0; index<restaurant.schedules.length; index++) {
      DateTime _openTime = DateTime(
        _now.year, _now.month, _now.day, DateConverter.convertStringTimeToDate(restaurant.schedules[index].openingTime).hour,
        DateConverter.convertStringTimeToDate(restaurant.schedules[index].openingTime).minute,
      );
      DateTime _closeTime = DateTime(
        _now.year, _now.month, _now.day, DateConverter.convertStringTimeToDate(restaurant.schedules[index].closingTime).hour,
        DateConverter.convertStringTimeToDate(restaurant.schedules[index].closingTime).minute,
      );
      if(_closeTime.difference(_openTime).isNegative) {
        _minutes = _openTime.difference(_closeTime).inMinutes;
      }else {
        _minutes = _closeTime.difference(_openTime).inMinutes;
      }
      if(_minutes > Get.find<SplashController>().configModel.scheduleOrderSlotDuration) {
        DateTime _time = _openTime;
        for(;;) {
          if(_time.isBefore(_closeTime)) {
            DateTime _start = _time;
            DateTime _end = _start.add(Duration(minutes: Get.find<SplashController>().configModel.scheduleOrderSlotDuration));
            if(_end.isAfter(_closeTime)) {
              _end = _closeTime;
            }
            _timeSlots.add(TimeSlotModel(day: restaurant.schedules[index].day, startTime: _start, endTime: _end));
            _allTimeSlots.add(TimeSlotModel(day: restaurant.schedules[index].day, startTime: _start, endTime: _end));
            _time = _time.add(Duration(minutes: Get.find<SplashController>().configModel.scheduleOrderSlotDuration));
          }else {
            break;
          }
        }
      }else {
        _timeSlots.add(TimeSlotModel(day: restaurant.schedules[index].day, startTime: _openTime, endTime: _closeTime));
        _allTimeSlots.add(TimeSlotModel(day: restaurant.schedules[index].day, startTime: _openTime, endTime: _closeTime));
      }
    }
    validateSlot(_allTimeSlots, 0, notify: false);
  }

  void updateTimeSlot(int index, {bool notify = true}) {
    _selectedTimeSlot = index;
    if(notify) {
      update();
    }
  }

  void updateTips(int index, {bool notify = true}) {
    _selectedTips = index;
    if(notify) {
      update();
    }
  }

  void updateDateSlot(int index) {
    _selectedDateSlot = index;
    _selectedTimeSlot = 0;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    update();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    int _day = 0;
    if(dateIndex == 0) {
      _day = DateTime.now().weekday;
    }else {
      _day = DateTime.now().add(Duration(days: 1)).weekday;
    }
    if(_day == 7) {
      _day = 0;
    }
    _slotIndexList = [];
    int _index = 0;
    for(int index=0; index<slots.length; index++) {
      if (_day == slots[index].day && (dateIndex == 0 ? slots[index].endTime.isAfter(DateTime.now()) : true)) {
        _timeSlots.add(slots[index]);
        _slotIndexList.add(_index);
        _index ++;
      }
    }
    if(notify) {
      update();
    }
  }

  Future<bool> switchToCOD(String orderID) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.switchToCOD(orderID);
    bool _isSuccess;
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }

  Future<double> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    Response response = await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _distance = DistanceModel.fromJson(response.body).rows[0].elements[0].distance.value / 1000;
      } else {
        _distance = Geolocator.distanceBetween(
          originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
        ) / 1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
        originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
      ) / 1000;
    }
    update();
    return _distance;
  }

}