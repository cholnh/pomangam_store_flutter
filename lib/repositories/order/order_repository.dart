import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/order/order_response.dart';

class OrderRepository {
  final Api api = Get.find(tag: 'api');

  Future<List<OrderResponse>> findByIdxStore({
    @required int sIdx,
    int dIdx,
    int ddIdx,
    int otIdx,
    @required String oDate,
    int last,
    PageRequest pageRequest
  }) async
  => OrderResponse.fromJsonList((await api.get(
      url: Url('/store/$sIdx/orders')
          .addParam('dIdx', dIdx)
          .addParam('ddIdx', ddIdx)
          .addParam('otIdx', otIdx)
          .addParam('oDate', oDate)
          .addParam('last', last)
          .toString(),
      pageRequest: pageRequest
    )).data);
}

class Url {
  String url;
  Url(this.url);
  Url addParam(String param, var value) {
    if(value != null) {
      this.url += this.url.contains('?') ? '&$param=$value' :  '?$param=$value';
    }
    return this;
  }
  String toString() {
    return this.url;
  }
}