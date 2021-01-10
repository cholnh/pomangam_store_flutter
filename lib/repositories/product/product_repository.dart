import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/product/product.dart';

class ProductRepository {

  final Api api = Get.find<Api>(tag: 'api');

  Future<List<Product>> findByIdxStore({
    @required int sIdx
  }) async => Product.fromJsonList(
      (await api.get(url: '/store/$sIdx/products')).data);
}