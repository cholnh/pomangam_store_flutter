import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/order/time/order_time.dart';

class OrderTimeRepository {
  final Api api = Get.find(tag: 'api');

  Future<List<OrderTime>> findByIdxDeliverySite({
    int sIdx,
    int dIdx
  }) async
    => OrderTime.fromJsonList((await api.get(url: '/store/$sIdx/ordertimes?dIdx=$dIdx')).data);
}