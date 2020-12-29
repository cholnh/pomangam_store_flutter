import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_switch.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends AppBar {
  HomeAppBar({Color backgroundColor}) : super (
    centerTitle: true,
    toolbarHeight: 60,
    automaticallyImplyLeading: true,
    leading: null,
    title: Consumer<StoreModel>(
      builder: (_, model, __) {
        return Column(
          children: [
            Text('포만감 풍동점', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            )),
            SizedBox(height: 3),
            Text(model.onOff == OrderOnOff.ON ? '주문 접수 중' : '주문 일시정지', style: TextStyle(
              color: Colors.white,
              fontSize: 13.0,
            )),
          ],
        );
      }
    ),
    backgroundColor: backgroundColor,
    actions: [
      Center(
        child: Consumer<StoreModel>(
          builder: (_, model, __) {
            return GestureDetector(
              onTap: () {
                if(model.onOff == OrderOnOff.ON) {
                  DialogUtils.dialogYesOrNo(Get.context, '당일 주문이 일시정지 됩니다.',
                      onConfirm: (_) {
                        model.changeOrderOnOff(OrderOnOff.OFF);
                      }
                  );
                } else {
                  model.changeOrderOnOff(OrderOnOff.ON);
                }
              },
              child: CustomSwitch(
                isLoading: model.isOnOffChanging,
                value: model.onOff == OrderOnOff.ON,
                onIcon: Icon(Icons.check, size: 20, color: Color.fromRGBO(0xff, 0x45, 0x00, 1.0)),
                offIcon: Icon(Icons.pause_sharp, size: 20, color: Colors.grey[400]),
              ),
            );
          },
        ),
      ),
      SizedBox(width: 15)
    ],
    elevation: 0,
  );
}
