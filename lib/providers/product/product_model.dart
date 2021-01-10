import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/product/product.dart';
import 'package:pomangam/repositories/product/product_repository.dart';

class ProductModel with ChangeNotifier {

  /// repository
  ProductRepository _productRepository = Get.find(tag: 'productRepository');

  /// data
  List<Product> products;

  Product viewSelected;

  void changeViewSelected(Product product) {
    this.viewSelected = product;
    notifyListeners();
  }

  Future<void> fetch({
    @required int sIdx
  }) async {
    try {
      this.products = await _productRepository.findByIdxStore(sIdx: sIdx);
      print(products);
    } catch (error) {
      debug('[Debug] ProductModel.fetch Error', error: error);
    } finally {
      notifyListeners();
    }
  }

}
