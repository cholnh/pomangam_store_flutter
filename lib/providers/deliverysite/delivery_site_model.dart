import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/repositories/delivery/delivery_site_repository.dart';


class DeliverySiteModel with ChangeNotifier {
  DeliverySiteRepository _deliverySiteRepository = Get.find(tag: 'deliverySiteRepository');

  List<DeliverySite> deliverySites = List();
  DeliverySite userDeliverySite;

  bool isFetching = false;
  bool isSearching = false;
  bool isChanging = false;

  Future<void> fetch({
    bool forceUpdate = false
  }) async {
    if(!forceUpdate && deliverySites.length > 0) return;

    isFetching = true;
    try {
      deliverySites = await _deliverySiteRepository.findAll();
    } catch (error) {
      print('[Debug] DeliverySiteModel.fetch Error - $error');
      isFetching = false;
    }
    isFetching = false;
    notifyListeners();
  }

  Future<void> search({
    String query
  }) async {
    if(query == null) return;

    isSearching = true;
    try {
      deliverySites = await _deliverySiteRepository.search(query: query);
    } catch (error) {
      print('[Debug] DeliverySiteModel.find Error - $error');
      isSearching = false;
    }
    isSearching = false;
    notifyListeners();
  }

  Future<void> changeUserDeliverySiteByIdx({
    @required int dIdx
  }) async {
    DeliverySite fetched;
    try {
      fetched = await _deliverySiteRepository.findByIdx(dIdx: dIdx);
    } catch (error) {
      print('[Debug] DeliverySiteModel.changeUserDeliverySite Error - $error');
    }
    changeUserDeliverySite(fetched);
  }

  void changeUserDeliverySite(DeliverySite deliverySite) async {
    this.userDeliverySite = deliverySite;
    notifyListeners();
  }

  void changeIsChanging(bool tf) {
    this.isChanging = tf;
    notifyListeners();
  }
}
