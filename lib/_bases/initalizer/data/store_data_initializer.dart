import 'package:get/get.dart';
import 'package:pomangam/_bases/util/log_utils.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:provider/provider.dart';

Future<bool> storeDataInitialize({int sIdx}) async
=> logProcess(
    name: 'storeDataInitialize',
    function: () async {
      await Get.context.read<StoreModel>().fetch(sIdx: sIdx);
      return true;
    }
);