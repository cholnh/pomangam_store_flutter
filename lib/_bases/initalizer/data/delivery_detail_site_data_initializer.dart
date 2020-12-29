import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;

Future<bool> deliveryDetailSiteDataInitialize({
  int ddIdx
}) async
=> logProcess(
    name: 'deliveryDetailSiteDataInitialize',
    function: () async {
      int dIdx = Get.context.read<DeliverySiteModel>().userDeliverySite.idx;
      if(ddIdx != null) {
        await Get.context.read<DeliveryDetailSiteModel>().changeUserDeliveryDetailSiteByIdx(dIdx: dIdx, ddIdx: ddIdx);
      } else {
        (await SharedPreferences.getInstance())
          ..setInt(s.idxDeliveryDetailSite, null);
      }
      return true;
    }
);