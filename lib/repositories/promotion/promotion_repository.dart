import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/promotion/promotion.dart';

class PromotionRepository {

  final Api api = Get.find<Api>(tag: 'api');

  Future<List<Promotion>> findByIdxDeliverySite({
    @required int dIdx
  }) async => Promotion.fromJsonList(
      (await api.get(url: '/dsites/$dIdx/promotions')).data);
}