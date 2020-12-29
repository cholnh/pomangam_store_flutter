import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/domains/store/schedule/store_schedule.dart';
import 'package:pomangam/domains/store/store.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/repositories/store/store_repository.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';

class StoreModel with ChangeNotifier {

  /// repository
  StoreRepository _storeRepository = Get.find(tag: 'storeRepository');

  /// data
  Store storeInfo;

  OrderOnOff onOff = OrderOnOff.ON;
  bool isOnOffChanging = false;

  Future<void> fetch({
    @required int sIdx
  }) async {
    try {
      this.storeInfo = await _storeRepository.findByIdx(sIdx: sIdx);
      this.onOff = storeInfo.storeSchedule.isOpening ? OrderOnOff.ON : OrderOnOff.OFF;
    } catch (error) {
      debug('[Debug] StoreModel.fetch Error', error: error);
    }
  }


  Future<void> changeOrderOnOff(OrderOnOff onOff) async {
    if(isOnOffChanging) return;
    try {
      isOnOffChanging = true;
      notifyListeners();

      await _storeRepository.patch(
          sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
          store: Store(storeSchedule: StoreSchedule(isOpening: onOff == OrderOnOff.ON))
      );
      this.onOff = onOff;
    } catch(error) {
      debug('StoreModel.changeOrderOnOff Error', error: error);
      DialogUtils.dialog(Get.context, '$error');
    } finally {
      isOnOffChanging = false;
      notifyListeners();
    }
  }

  void toggleOrderOnOff() {
    if(this.onOff == OrderOnOff.ON) {
      this.onOff = OrderOnOff.OFF;
    } else {
      this.onOff = OrderOnOff.ON;
    }
    notifyListeners();
  }
}
