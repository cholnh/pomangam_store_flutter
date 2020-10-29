import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/repositories/order/order_repository.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderModel with ChangeNotifier {

  /// repository
  OrderRepository _orderRepository = Get.find(tag: 'orderRepository');

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

  /// model fetch
  Future<void> fetchAll({
    int dIdx,
    int ddIdx,
    int otIdx,
    @required DateTime oDate,
    bool isForceUpdate = false
  }) async {
    print('orders fetchAll! (sIdx: ${Get.context.read<SignInModel>().ownerInfo.idxStore}, dIdx: $dIdx, ddIdx: $ddIdx, otIdx: $otIdx, oDate: $oDate, last: $last)');

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
    print('orders fetchNew! (sIdx: ${Get.context.read<SignInModel>().ownerInfo.idxStore}, dIdx: $dIdx, ddIdx: $ddIdx, otIdx: $otIdx, oDate: $oDate, last: $last)');
    if(last == null) return;
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

  bool _isValidType(OrderType orderType) {
    switch(orderType) {
      case OrderType.PAYMENT_READY:
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.PAYMENT_CANCEL:
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
    orders.clear();
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

  void changeOrderOnOff(OrderOnOff onOff) {
    this.onOff = onOff;
    notifyListeners();
  }
}