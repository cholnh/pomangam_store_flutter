import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/promotion/promotion.dart';
import 'package:pomangam/repositories/promotion/promotion_repository.dart';

class PromotionModel with ChangeNotifier {

  /// repository
  PromotionRepository _promotionRepository = Get.find(tag: 'promotionRepository');

  /// data
  List<Promotion> promotions = [];

  Future<List<Promotion>> fetchByIdxDeliverySite({
    @required int dIdx
  }) async {
    try {
      this.promotions = await _promotionRepository.findByIdxDeliverySite(dIdx: dIdx);
      return this.promotions;
    } catch (error) {
      debug('[Debug] PromotionModel.fetchByIdxDeliverySite Error', error: error);
      return null;
    } finally {
      notifyListeners();
    }
  }

  void clear({bool notify = true}) {
    this.promotions.clear();
    if(notify) {
      notifyListeners();
    }
  }
}
