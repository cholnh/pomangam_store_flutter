import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';

class DeliverySiteRepository {
  final Api api = Get.find(tag: 'api');

  Future<List<DeliverySite>> findAll() async
    => DeliverySite.fromJsonList((await api.get(url: '/dsites')).data);

  Future<DeliverySite> findByIdx({int dIdx}) async
    => DeliverySite.fromJson((await api.get(url: '/dsites/$dIdx')).data);

  Future<List<DeliverySite>> search({String query}) async
    => DeliverySite.fromJsonList((await api.get(url: '/dsites/search?query=$query')).data);

  Future<List<DeliverySite>> fetchByIdxStore({int sIdx}) async
  => DeliverySite.fromJsonList((await api.get(url: '/dsites?sIdx=$sIdx')).data);

}