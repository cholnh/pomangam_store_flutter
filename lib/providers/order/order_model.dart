import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/item/sub/order_item_sub_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/domains/store/schedule/store_schedule.dart';
import 'package:pomangam/domains/store/store.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/repositories/order/order_repository.dart';
import 'package:pomangam/repositories/store/store_repository.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderModel with ChangeNotifier {

  /// repository
  OrderRepository _orderRepository = Get.find(tag: 'orderRepository');
  StoreRepository _storeRepository = Get.find(tag: 'storeRepository');

  /// model
  List<OrderResponse> orders = List();

  /// data
  bool isFetching = false;
  bool isNewFetching = false;
  bool hasNext = true;
  int curPage = 0;
  int size = 200;
  int last;
  OrderOnOff onOff = OrderOnOff.ON;
  bool isOnOffChanging = false;

  /// model fetch
  Future<void> fetchAll({
    int dIdx,
    int ddIdx,
    int otIdx,
    @required DateTime oDate,
    bool isForceUpdate = false
  }) async {
    //print('orders fetchAll! (sIdx: ${Get.context.read<SignInModel>().ownerInfo.idxStore}, dIdx: $dIdx, ddIdx: $ddIdx, otIdx: $otIdx, oDate: $oDate, last: $last)');
    if(!isForceUpdate && !hasNext) return;
    hasNext = false; // lock
    isFetching = true;

    if(isForceUpdate) {
      notifyListeners();
    }

    List<OrderResponse> fetched = [];
    if(isForceUpdate) {
      curPage = 0;
      size = 200;
      orders.clear();
    }

    try {
      fetched = await _orderRepository.findByIdxStore(
        sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
        dIdx: dIdx,
        ddIdx: ddIdx,
        otIdx: otIdx,
        oDate: DateFormat('yyyy-MM-dd').format(oDate),
        pageRequest: PageRequest(
          page: curPage++,
          size: size
        )
      );

      if(fetched != null && fetched.isNotEmpty) {
        fetched = fetched.where((item) => _isValidType(item.orderType)).toList();
        fetched.forEach((e) {
          int idx = e.idx;
          last = last == null
            ? idx
            : (last < idx ? idx : last);
        });
      }

      orders.addAll(fetched);
      hasNext = fetched.length >= size;

    } catch (error) {
      debug('OrderModel.fetchAll Error', error: error);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Future<void> fetchNew({
    int dIdx,
    int ddIdx,
    int otIdx,
    @required DateTime oDate,
  }) async {
    //print('orders fetchNew! (sIdx: ${Get.context.read<SignInModel>().ownerInfo.idxStore}, dIdx: $dIdx, ddIdx: $ddIdx, otIdx: $otIdx, oDate: $oDate, last: $last)');
    if(isFetching || isNewFetching) return;
    isNewFetching = true;
    notifyListeners();

    List<OrderResponse> fetched = [];
    try {
      fetched = await _orderRepository.findByIdxStore(
        sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
        dIdx: dIdx,
        ddIdx: ddIdx,
        otIdx: otIdx,
        oDate: DateFormat('yyyy-MM-dd').format(oDate),
        last: last,
        pageRequest: PageRequest(
          page: 0,
          size: 9999
        )
      );

      if(fetched != null && fetched.isNotEmpty) {
        fetched = fetched.where((item) => _isValidType(item.orderType)).toList();

        orders.insertAll(0, fetched);
        fetched.forEach((e) {
          int idx = e.idx;
          last = last == null
              ? idx
              : (last < idx ? idx : last);
        });
      }
    } catch (error) {
      debug('OrderModel.fetchNew Error', error: error);
    } finally {
      isNewFetching = false;
      notifyListeners();
    }
  }

  Future<void> approve({
    @required int sIdx,
    @required int oIdx
  }) async {
    if(isOrderChanging(oIdx)) return;

    try {
      orderChanging(oIdx, true);
      notifyListeners();

      OrderResponse order = await _orderRepository.approve(
        sIdx: sIdx,
        oIdx: oIdx
      );
      _changeOrder(order);
    } catch(error) {
      debug('OrderModel.approve Error', error: error);
    } finally {
      orderChanging(oIdx, false);
      notifyListeners();
    }
  }

  Future<void> disapprove({
    @required int sIdx,
    @required int oIdx,
    String reason
  }) async {
    if(isOrderChanging(oIdx)) return;

    try {
      orderChanging(oIdx, true);
      notifyListeners();

      OrderResponse order = await _orderRepository.disapprove(
        sIdx: sIdx,
        oIdx: oIdx,
        reason: reason
      );
      _changeOrder(order);
    } catch(error) {
      debug('OrderModel.disapprove Error', error: error);
    } finally {
      orderChanging(oIdx, false);
      notifyListeners();
    }
  }

  Future<void> deliveryPickup({
    @required int sIdx,
    @required int oIdx,
  }) async {
    if(isOrderChanging(oIdx)) return;

    try {
      orderChanging(oIdx, true);
      notifyListeners();

      OrderResponse order = await _orderRepository.deliveryPickup(
        sIdx: sIdx,
        oIdx: oIdx,
      );
      _changeOrder(order);
    } catch(error) {
      debug('OrderModel.deliveryPickup Error', error: error);
    } finally {
      orderChanging(oIdx, false);
      notifyListeners();
    }
  }

  Future<void> deliveryDelay({
    @required int sIdx,
    @required int oIdx,
    String reason
  }) async {
    if(isOrderChanging(oIdx)) return;

    try {
      orderChanging(oIdx, true);
      notifyListeners();

      OrderResponse order = await _orderRepository.deliveryDelay(
        sIdx: sIdx,
        oIdx: oIdx,
        reason: reason
      );
      _changeOrder(order);
    } catch(error) {
      debug('OrderModel.deliveryDelay Error', error: error);
    } finally {
      orderChanging(oIdx, false);
      notifyListeners();
    }
  }

  Future<void> deliverySuccess({
    @required int sIdx,
    @required int oIdx,
  }) async {
    if(isOrderChanging(oIdx)) return;

    try {
      orderChanging(oIdx, true);
      notifyListeners();

      OrderResponse order = await _orderRepository.deliverySuccess(
        sIdx: sIdx,
        oIdx: oIdx,
      );
      _changeOrder(order);
    } catch(error) {
      debug('OrderModel.deliverySuccess Error', error: error);
    } finally {
      orderChanging(oIdx, false);
      notifyListeners();
    }
  }

  void _changeOrder(OrderResponse changed) {
    int index = this.orders.indexWhere((order) => order.idx == changed.idx);
    if(_isValidType(changed.orderType)) {
      this.orders.replaceRange(index, index+1, List()..add(changed));
    } else {
      this.orders.removeAt(index);
    }
  }

  bool _isValidType(OrderType orderType) {
    switch(orderType) {
      case OrderType.PAYMENT_READY:
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.PAYMENT_CANCEL:
      case OrderType.PAYMENT_REFUND:
        return false;
      default:
        return true;
    }
  }

  void clear({bool notify = true}) {
    isFetching = false;
    isNewFetching = false;
    hasNext = true;
    curPage = 0;
    size = 200;
    last = null;
    isOnOffChanging = false;
    orders.clear();
    clearOrderChanging();
    if(notify) {
      notifyListeners();
    }
  }

  void toggleOrderOnOff() {
    if(this.onOff == OrderOnOff.ON) {
      this.onOff = OrderOnOff.OFF;
    } else {
      this.onOff = OrderOnOff.ON;
    }
    notifyListeners();
  }

  Future<void> changeOrderOnOff(OrderOnOff onOff) async {
    if(isOnOffChanging) return;
    try {
      isOnOffChanging = true;
      notifyListeners();

      await _storeRepository.patch(
        sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
        store: Store(storeSchedule: StoreSchedule(isOpening: onOff == OrderOnOff.ON))
      );
      this.onOff = onOff;
    } catch(error) {
      debug('OrderModel.changeOrderOnOff Error', error: error);
      DialogUtils.dialog(Get.context, '$error');
    } finally {
      isOnOffChanging = false;
      notifyListeners();
    }
  }

  void orderItemToggle(int oIdx) {
    for(OrderResponse order in this.orders) {
      for(OrderItemResponse item in order.orderItems) {
        if(item.idx == oIdx) {
          item.isSelected = !item.isSelected;
          notifyListeners();
          return;
        }
      }
    }
  }

  void orderSubItemToggle(int osIdx) {
    for(OrderResponse order in this.orders) {
      for(OrderItemResponse item in order.orderItems) {
        for(OrderItemSubResponse sub in item.orderItemSubs) {
          if(sub.idx == osIdx) {
            sub.isSelected = !sub.isSelected;
            notifyListeners();
            return;
          }
        }
      }
    }
  }

  void orderChanging(int oIdx, bool isChanging) {
    for(OrderResponse order in this.orders) {
      if(order.idx == oIdx) {
        order.isChanging = isChanging;
        return;
      }
    }
  }

  bool isOrderChanging(int oIdx) {
    for(OrderResponse order in this.orders) {
      if(order.idx == oIdx) {
        return order.isChanging;
      }
    }
    return false;
  }

  void clearOrderChanging() {
    for(OrderResponse order in this.orders) {
      order.isChanging = false;
    }
  }
}