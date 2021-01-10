import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:provider/provider.dart';

Future<bool> orderTimeDataInitialize() async
=> logProcess(
    name: 'orderTimeDataInitialize',
    function: () async {
      OrderTimeModel orderTimeModel = Get.context.read<OrderTimeModel>();
      DeliverySiteModel deliverySiteModel = Get.context.read();

      orderTimeModel.userOrderDate ??= DateTime.now();

      if(deliverySiteModel.userDeliverySite != null) {
        int dIdx = deliverySiteModel.userDeliverySite.idx;
        await orderTimeModel.fetch(forceUpdate: true, dIdx: dIdx);
      }

      return true;
    }
);