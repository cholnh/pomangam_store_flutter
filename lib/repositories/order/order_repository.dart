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
    String oDate,
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

  Future<OrderResponse> approve({
    @required int sIdx,
    @required int oIdx
  }) async => OrderResponse.fromJson((await api.post(url: '/store/$sIdx/orders/$oIdx/approve')).data);

  Future<OrderResponse> disapprove({
    @required int sIdx,
    @required int oIdx,
    String reason
  }) async => OrderResponse.fromJson((await api.post(url: '/store/$sIdx/orders/$oIdx/disapprove' + (reason != null ? '?reason=$reason' : ''))).data);

  Future<OrderResponse> deliveryPickup({
    @required int sIdx,
    @required int oIdx
  }) async => OrderResponse.fromJson((await api.post(url: '/store/$sIdx/orders/$oIdx/deliveries/pickup')).data);

  Future<OrderResponse> deliveryDelay({
    @required int sIdx,
    @required int oIdx,
    @required int min,
    String reason
  }) async => OrderResponse.fromJson((await api.post(url: '/store/$sIdx/orders/$oIdx/deliveries/delay?min=$min' + (reason != null ? '&reason=$reason' : ''))).data);

  Future<OrderResponse> deliverySuccess({
    @required int sIdx,
    @required int oIdx
  }) async => OrderResponse.fromJson((await api.post(url: '/store/$sIdx/orders/$oIdx/deliveries/success')).data);
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