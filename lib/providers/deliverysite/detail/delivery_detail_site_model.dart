import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/deliverysite/detail/delivery_detail_site.dart';
import 'package:pomangam/repositories/delivery/detail/delivery_detail_site_repository.dart';

class DeliveryDetailSiteModel with ChangeNotifier {
  DeliveryDetailSiteRepository _deliveryDetailSiteRepository = Get.find(tag: 'deliveryDetailSiteRepository');

  List<DeliveryDetailSite> deliveryDetailSites = List();
  DeliveryDetailSite userDeliveryDetailSite;

  DeliveryDetailSite selected;
  DeliveryDetailSite viewSelected;

  bool isFetching = false;

  Future<void> fetch({
    bool forceUpdate = false,
    @required int dIdx
  }) async {
    if(!forceUpdate && deliveryDetailSites.length > 0) return;
    isFetching = true;

    try {
      deliveryDetailSites = await _deliveryDetailSiteRepository.findAll(dIdx: dIdx);
    } catch (error) {
      print('[Debug] DeliveryDetailSiteModel.fetch Error - $error');
      isFetching = false;
    }
    isFetching = false;
    notifyListeners();
  }

  Future<void> changeUserDeliveryDetailSiteByIdx({
    @required int dIdx,
    @required int ddIdx
  }) async {
    DeliveryDetailSite fetched;
    try {
      fetched = await _deliveryDetailSiteRepository.findByIdx(dIdx: dIdx, ddIdx: ddIdx);
    } catch (error) {
      print('[Debug] DeliveryDetailSiteModel.changeUserDeliveryDetailSite Error - $error');
    }
    changeUserDeliveryDetailSite(fetched);
  }

  void changeUserDeliveryDetailSite(DeliveryDetailSite deliveryDetailSite) {
    this.userDeliveryDetailSite = deliveryDetailSite;
    notifyListeners();
  }

  void changeSelected(DeliveryDetailSite detailSite) {
    this.selected = detailSite;
    notifyListeners();
  }

  void changeViewSelected(DeliveryDetailSite detailSite) {
    this.viewSelected = detailSite;
    notifyListeners();
  }

  void clear({bool notify = true}) {
    this.deliveryDetailSites.clear();
    this.selected = null;
    this.viewSelected = null;
    if(notify) {
      notifyListeners();
    }
  }
}
