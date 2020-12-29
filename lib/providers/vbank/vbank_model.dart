import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/vbank/vbank.dart';
import 'package:pomangam/repositories/vbank/vbank_repository.dart';

class VBankModel with ChangeNotifier {

  /// repository
  VBankRepository _vBankRepository = Get.find(tag: 'vbankRepository');

  /// model
  List<VBank> deposits = List();

  /// data
  bool isFetching = false;
  bool hasNext = true;
  int curPage = Endpoint.defaultPage;
  int size = Endpoint.defaultSize;

  /// model fetch
  Future<void> fetchAll({
    bool isForceUpdate = false
  }) async {
    if(!isForceUpdate && !hasNext) return;
    hasNext = false; // lock
    isFetching = true;

    List<VBank> fetched = [];
    if(isForceUpdate) {
      curPage = Endpoint.defaultPage;
      size = Endpoint.defaultSize;
      deposits.clear();
    }

    try {
      fetched = await _vBankRepository.findDeposit(
        pageRequest: PageRequest(
          page: curPage++,
          size: size
        )
      );
      deposits.addAll(fetched);
      hasNext = fetched.length >= size;

    } catch (error) {
      debug('VBankModel.fetchAll Error', error: error);
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  void clear({bool notify = true}) {
    isFetching = false;
    hasNext = true;
    curPage = Endpoint.defaultPage;
    size = Endpoint.defaultSize;
    deposits.clear();
    if(notify) {
      notifyListeners();
    }
  }
}