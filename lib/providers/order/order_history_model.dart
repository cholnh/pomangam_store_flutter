import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/repositories/order/order_repository.dart';
import 'package:provider/provider.dart';

class OrderHistoryModel with ChangeNotifier {

  /// repository
  OrderRepository _orderRepository = Get.find(tag: 'orderRepository');

  /// model
  List<OrderResponse> orders = List();

  /// data
  bool isFetching = false;
  bool hasNext = true;
  int curPage = Endpoint.defaultPage;
  int size = Endpoint.defaultSize;

  /// model fetch
  Future<void> fetchAll({
    int dIdx,
    int ddIdx,
    int otIdx,
    DateTime oDate,
    bool isForceUpdate = false
  }) async {
    if(!isForceUpdate && !hasNext) return;
    hasNext = false; // lock
    isFetching = true;

    if(isForceUpdate) {
      notifyListeners();
    }

    List<OrderResponse> fetched = [];
    try {
      int sIdx = Get.context.read<SignInModel>().ownerInfo.idxStore;
      fetched = await _orderRepository.findByIdxStore(
        sIdx: sIdx,
        dIdx: dIdx,
        ddIdx: ddIdx,
        otIdx: otIdx,
        oDate: oDate == null ? null : DateFormat('yyyy-MM-dd').format(oDate),
        pageRequest: PageRequest(
          page: curPage++,
          size: size
        )
      );

      orders.addAll(fetched);
      hasNext = fetched.length >= size;

    } catch (error) {
      debug('OrderHistoryModel.fetchAll Error', error: error);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  void clear({bool notify = true}) {
    isFetching = false;
    hasNext = true;
    curPage = Endpoint.defaultPage;
    size = Endpoint.defaultSize;
    orders.clear();
    if(notify) {
      notifyListeners();
    }
  }
}