import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:provider/provider.dart';

Future<bool> deliverySiteDataInitialize({
  int dIdx
}) async
=> logProcess(
    name: 'deliverySiteDataInitialize',
    function: () async {
      await Get.context.read<DeliverySiteModel>().changeUserDeliverySiteByIdx(dIdx: dIdx);
      return true;
    }
);