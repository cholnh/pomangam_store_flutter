import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/store/store.dart';

class StoreRepository {

  final Api api = Get.find<Api>(tag: 'api');

  Future<Store> findByIdx({
    @required int sIdx
  }) async => Store.fromJson(
      (await api.get(url: '/store/$sIdx')).data);

  Future<Store> patch({
    @required int sIdx,
    @required Store store
  }) async => Store.fromJson(
      (await api.patch(
        url: '/store/$sIdx',
        data: store.toJson()
      )).data);
}