import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/time/order_time.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/repositories/order/time/order_time_repository.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';

class OrderTimeModel with ChangeNotifier {

  /// repository
  OrderTimeRepository _orderTimeRepository = Get.find(tag: 'orderTimeRepository');

  /// data
  List<OrderTime> orderTimes = List();
  OrderTime userOrderTime;
  DateTime userOrderDate;

  DateTime selectedOrderDate;
  DateTime viewSelectedOrderDate;
  OrderTime selected;
  OrderTime viewSelected;

  bool isOrderDateMode = false;
  bool isOrderDateChanged = false;
  DateTime viewUserOrderDate;

  void clear({bool notify = true}) {
    this.orderTimes.clear();
    this.selected = null;
    this.viewSelected = null;
    this.userOrderTime = null;
    if(notify) {
      notifyListeners();
    }
  }

  void changeSelectedOrderDate(DateTime orderDate) {
    this.selectedOrderDate = orderDate;
    notifyListeners();
  }

  void changeViewSelectedOrderDate(DateTime orderDate) {
    this.viewSelectedOrderDate = orderDate;
    notifyListeners();
  }

  void changeSelected(OrderTime orderTime) {
    this.selected = orderTime;
    notifyListeners();
  }

  void changeViewSelected(OrderTime orderTime) {
    this.viewSelected = orderTime;
    notifyListeners();
  }

  Future<void> fetch({
    bool forceUpdate = false,
    @required int dIdx
  }) async {
    if(!forceUpdate && orderTimes.length > 0) return;

    try {
      orderTimes = await _orderTimeRepository.findByIdxDeliverySite(
        sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
        dIdx: dIdx
      );
    } catch (error) {
      print('[Debug] OrderTimeModel.fetch Error - $error');
    }
    renewOrderableFirstTime(notify: true);
  }

  OrderTime orderableFirstTime() {
    userOrderDate = userOrderDate ?? DateTime.now();
    return null;

    // DateTime now = DateTime.now();
    // for(OrderTime orderTime in orderTimes) {
    //   if(now.isBefore(orderTime.getOrderEndDateTime())) {
    //     userOrderDate = now;
    //     return orderTime;
    //   }
    // }
    // userOrderDate = now + 1.days;
    // return orderTimes.first;
  }

  bool isOverUserTime() {
    DateTime now = DateTime.now();
    return (now.year >= userOrderDate.year && now.month >= userOrderDate.month && now.day >= userOrderDate.day) &&
        userOrderTime.getOrderEndDateTime().isBefore(now);
  }

  void renewOrderableFirstTime({bool notify = true}) {
    userOrderTime = orderableFirstTime();
    if(notify) {
      notifyListeners();
    }
  }

  void changeUserOrderTime(OrderTime orderTime) {
    this.userOrderTime = orderTime;
    notifyListeners();
  }

  void changeUserOrderDate(DateTime userOrderDate) {
    this.userOrderDate = userOrderDate;
    notifyListeners();
  }

  void changeUserOrderDateAndOrderTime(DateTime orderDate, OrderTime orderTime) {
    this.userOrderDate = orderDate;
    this.userOrderTime = orderTime;
    notifyListeners();
  }

  void changeViewUserOrderDate(DateTime viewUserOrderDate) {
    this.isOrderDateChanged = true;
    this.viewUserOrderDate = viewUserOrderDate;
    notifyListeners();
  }

  void changeOrderDateMode(bool tf) {
    this.isOrderDateMode = tf;
    notifyListeners();
  }

  DateTime getPickUpTime(int otIdx) {
    if(!orderTimes.isNullOrBlank) {
      for(OrderTime orderTime in orderTimes) {
        if(orderTime.idx == otIdx) {
          return orderTime.getPickUpDateTime();
        }
      }
    }
    return null;
  }
}
