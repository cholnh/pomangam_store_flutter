import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/pages/deliverysite/delivery_site_page.dart';
import 'package:pomangam/views/mobile/widgets/order/view/time_picker/order_time_picker_modal.dart';
import 'package:provider/provider.dart';

class OrderViewAppBar extends AppBar {
  OrderViewAppBar() : super (
    centerTitle: false,
    automaticallyImplyLeading: true,
    title: Row(
      children: [
        GestureDetector(
          onTap: _dsiteTap,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 30, top: 10, bottom: 10),
              child: Row(
                children: [
                  Column(
                    children: [
                      Consumer<DeliverySiteModel>(
                        builder: (_, model, __) {
                          return Text('${model.userDeliverySite.name}', style: const TextStyle(fontSize: 15.0, color: Colors.black));
                        }
                      ),
                      Consumer<DeliveryDetailSiteModel>(
                        builder: (_, model, __) {
                          return Text(model.userDeliveryDetailSite.isNull
                            ? '전체'
                            : '${model.userDeliveryDetailSite.name}', style: const TextStyle(fontSize: 11, color: Colors.grey));
                        }
                      )
                    ],
                  ),
                  // SizedBox(width: 3),
                  // Icon(Icons.arrow_drop_down, color: Theme.of(Get.context).primaryColor),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 60.0,
          width: 0.5,
          color: Colors.grey[400],
        ),
        GestureDetector(
          onTap: _showModal,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
              child: Consumer<OrderTimeModel>(
                builder: (_, model, child) {
                  bool isToday = _isToday(model.userOrderDate); // model.userOrderDate?.isAfter(DateTime.now());

                  var textArrivalDate = !isToday ? ' ${DateFormat('MM월 dd일').format(model.userOrderDate)}' : ' 오늘';
                  var textArrivalTime = '';

                  if(model.userOrderTime.isNull) {
                    textArrivalTime = '전체';
                  } else {
                    int h = model.userOrderTime.getArrivalDateTime().hour;
                    int m = model.userOrderTime.getArrivalDateTime().minute;
                    var textMinute = m == 0 ? '' : '$m분 ';
                    textArrivalTime = '$h시 $textMinute' + (!isToday ? '예약' : '도착');
                  }

                  return Row(
                    children: <Widget>[
                      Column(
                        children: [
                          Text('$textArrivalTime', style: const TextStyle(fontSize: 15.0, color: Colors.black)),
                          Text('$textArrivalDate', style: const TextStyle(fontSize: 11.0, color: Colors.grey)),
                        ],
                      ),
                      // SizedBox(width: 3),
                      // Text('$textArrivalTime$textArrivalDate', style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                      // Icon(Icons.arrow_drop_down, color: Theme.of(Get.context).primaryColor)
                    ],
                  );
                }
              ),
            ),
          ),
        ),
        Container(
          height: 60.0,
          width: 0.5,
          color: Colors.grey[400],
        ),
      ],
    ),
    actions: [
      // OrderViewSortPicker(
      //   child: Padding(
      //     padding: const EdgeInsets.all(15.0),
      //     child: Row(
      //       children: [
      //         Center(child: Text('필터', style: TextStyle(fontSize: 12.0, color: Theme.of(Get.context).textTheme.headline1.color))),
      //         SizedBox(width: 3),
      //         Icon(Icons.swap_vert, color: Theme.of(Get.context).textTheme.headline1.color, size: 20),
      //       ],
      //     ),
      //   ),
      //   onChanged: _fetch
      // ),
      Icon(Icons.settings_outlined, size: 20, color: Theme.of(Get.context).textTheme.headline1.color),
      SizedBox(width: 15)
    ],
    elevation: 1.0,
  );
}

void _dsiteTap() {
  Get.to(DeliverySitePage());
}

void _showModal() {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0))
    ),

    isScrollControlled: true,
    context: Get.context,
    builder: (context) {
      return OrderTimePickerModal();
    }
  );
}

bool _isToday(DateTime dt) {
  DateTime now = DateTime.now();
  return dt.year == now.year && dt.month == now.month && dt.day == now.day;
}