import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:provider/provider.dart';

Future<bool> deliverySiteDataInitialize({
  int sIdx,
  int dIdx,
}) async
=> logProcess(
    name: 'deliverySiteDataInitialize',
    function: () async {
      DeliverySiteModel deliverySiteModel = Get.context.read();

      await deliverySiteModel.fetchByIdxStore(sIdx: sIdx);
      if(deliverySiteModel.userDeliverySites.isNotEmpty) {
        if(dIdx == null) {
          deliverySiteModel.changeUserDeliverySite(deliverySiteModel.userDeliverySites.first);
        } else {
          bool isChanged = false;
          for(DeliverySite dsite in deliverySiteModel.userDeliverySites) {
            if(dsite.idx == dIdx) {
              deliverySiteModel.changeUserDeliverySite(dsite);
              isChanged = true;
              break;
            }
          }
          if(!isChanged) {
            deliverySiteModel.changeUserDeliverySite(deliverySiteModel.userDeliverySites.first);
          }
        }
        return true;
      } else {
        print('가게 등록 필요.');
        return false;
      }
    }
);