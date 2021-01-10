import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/time/order_time.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderAddOrderDateTimeSelectWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    OrderTimeModel orderTimeModel = context.watch();
    return Column(
      children: [
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            color: Colors.grey[100],
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${DateFormat('yyyy년 MM월 dd일').format(orderTimeModel.viewSelectedOrderDate ?? DateTime.now())}', style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  )),
                  Text('변경', style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          color: Colors.grey[100],
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _items(orderTimeModel),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _items(OrderTimeModel orderTimeModel) {
    List<Widget> items = List();
    for(int i=0; i<orderTimeModel.orderTimes.length; i++) {
      OrderTime orderTime = orderTimeModel.orderTimes[i];
      items.add(GestureDetector(
        onTap: () {
          orderTimeModel.changeViewSelected(orderTime);
        },
        child: RadioListTile(
          title: Text('${_textOrderTime(orderTime)}', style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
          value: orderTimeModel.viewSelected?.idx == orderTime.idx,
          groupValue: true,

        ),
      ));
    }
    return items;
  }

  void _showDatePicker() {
    OrderTimeModel orderTimeModel = Get.context.read();
    DateTime now = DateTime.now();
    DateTime max = DateTime(now.year, 12, 31);
    DatePicker.showDatePicker(
      Get.context,
      initialDateTime: orderTimeModel.selectedOrderDate ?? now,
      locale: DateTimePickerLocale.ko,
      minDateTime: now,
      maxDateTime: max,
      onConfirm: (DateTime dateTime, List<int> selectedIndex) {
        OrderTimeModel orderTimeModel = Get.context.read();
        orderTimeModel.changeViewSelectedOrderDate(dateTime);
      },
      pickerTheme: DateTimePickerTheme(
        pickerHeight: 150,
      )
    );
  }

  String _textOrderTime(OrderTime ot) {
    if(ot == null) return '';
    DateTime dt = ot.getArrivalDateTime();
    DateFormat formatter = DateFormat('a');
    String ampm = formatter.format(dt).toUpperCase() == 'PM' ? '오후' : '오전';
    return DateFormat('$ampm hh시 mm분').format(dt);
  }

}
