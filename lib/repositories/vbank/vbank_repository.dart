import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/_bases/page_request.dart';
import 'package:pomangam/domains/vbank/vbank.dart';

class VBankRepository {

  final Api api = Get.find<Api>(tag: 'api');

  Future<List<VBank>> findDeposit({
    PageRequest pageRequest
  }) async => VBank.fromJsonList(
      (await api.get(url: '/vbank', pageRequest: pageRequest)).data);
}