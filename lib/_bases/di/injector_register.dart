import 'package:get/get.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/network/api/api.dart';
import 'package:pomangam/_bases/network/repository/authorization_repository.dart';
import 'package:pomangam/_bases/network/repository/resource_repository.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/repositories/delivery/delivery_site_repository.dart';
import 'package:pomangam/repositories/delivery/detail/delivery_detail_site_repository.dart';
import 'package:pomangam/repositories/order/order_repository.dart';
import 'package:pomangam/repositories/order/time/order_time_repository.dart';
import 'package:pomangam/repositories/sign/sign_repository.dart';

class InjectorRegister {

  static register() {
    try {
      Get
        ..put(OauthTokenRepository(), tag: 'oauthTokenRepository')
        ..put(ResourceRepository(), tag: 'resourceRepository')
        ..put(Api(), tag: 'api')
        ..put(Initializer(), tag: 'initializer')
        ..put(SignRepository(), tag: 'signRepository')
        ..put(OrderTimeRepository(), tag: 'orderTimeRepository')
        ..put(OrderRepository(), tag: 'orderRepository')
        ..put(DeliverySiteRepository(), tag: 'deliverySiteRepository')
        ..put(DeliveryDetailSiteRepository(), tag: 'deliveryDetailSiteRepository')
      ;
      logWithDots('register', 'InjectorRegister.register', 'success');
    } catch (error) {
      logWithDots('register', 'InjectorRegister.register', 'failed', error: error);
    }
  }
}