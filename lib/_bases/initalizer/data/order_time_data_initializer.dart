import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:provider/provider.dart';

Future<bool> orderTimeDataInitialize({
  int sIdx
}) async
=> logProcess(
    name: 'orderTimeDataInitialize',
    function: () async {
      OrderTimeModel orderTimeModel = Get.context.read<OrderTimeModel>();
      await orderTimeModel.fetch(forceUpdate: true, sIdx: sIdx);
      return true;
    }
);