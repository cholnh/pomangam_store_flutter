import 'package:get/get.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/domains/deliverysite/detail/delivery_detail_site.dart';

class DeliveryDetailSiteRepository {
  final Api api = Get.find(tag: 'api');

  Future<List<DeliveryDetailSite>> findAll({int dIdx}) async
    => DeliveryDetailSite.fromJsonList((await api.get(url: '/dsites/$dIdx/details')).data);

  Future<DeliveryDetailSite> findByIdx({int dIdx, int ddIdx}) async
    => DeliveryDetailSite.fromJson((await api.get(url: '/dsites/${dIdx == null ? '0' : dIdx}/details/$ddIdx')).data);
}