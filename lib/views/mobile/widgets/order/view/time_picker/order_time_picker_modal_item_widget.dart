import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/time/order_time.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:provider/provider.dart';

class OrderTimePickerModalItemWidget extends StatelessWidget {

  final OrderTimeModel model;
  final Function onSelected;

  OrderTimePickerModalItemWidget({this.model, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: model.orderTimes.length + 1,
        itemBuilder: (BuildContext context, int index) {

          if(index == 0) return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: model.userOrderTime != null
                ? Text('전체', style: TextStyle(fontSize: 14.0))
                : Row(
                    children: <Widget>[
                      Text(
                        '전체',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(Get.context).primaryColor
                        )
                      ),
                      const Padding(padding: EdgeInsets.all(3)),
                      Icon(Icons.check, color: Theme.of(Get.context).primaryColor, size: 18.0)
                    ],
                ),
              onTap: () => _onSelected(context, null),
            ),
          );

          bool isNextDay = model.viewUserOrderDate.isAfter(DateTime.now());
          bool isSameDay =
              model.viewUserOrderDate.year == model.userOrderDate.year &&
                  model.viewUserOrderDate.month == model.userOrderDate.month &&
                  model.viewUserOrderDate.day == model.userOrderDate.day;

          OrderTime orderTime = model.orderTimes[index - 1];

          // if(!isNextDay && orderTime.getOrderEndDateTime().isBefore(DateTime.now())) {
          //   return Container();
          // }
          int h = orderTime.getArrivalDateTime().hour;
          int m = orderTime.getArrivalDateTime().minute;
          var textMinute = m == 0 ? '' : '$m분 ';
          var textArrivalTime = '$h시 $textMinute' + (isNextDay ? '예약' : '도착');
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: model.userOrderTime == null || orderTime.idx != model.userOrderTime.idx
                ? Text('$textArrivalTime', style: TextStyle(fontSize: 14.0))
                : Row(
                  children: <Widget>[
                    Text(
                      '$textArrivalTime',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: isSameDay ? FontWeight.bold : FontWeight.normal,
                        color: isSameDay ? Theme.of(Get.context).primaryColor : Colors.black
                      )
                    ),
                    isSameDay ? const Padding(padding: EdgeInsets.all(3)) : Container(),
                    isSameDay ? Icon(Icons.check, color: Theme.of(Get.context).primaryColor, size: 18.0) : Container()
                  ],
                ),
              onTap: () => _onSelected(context, orderTime),
            ),
          );
        },
      ),
    );
  }

  void _onSelected(BuildContext context, OrderTime orderTime) {
    Navigator.pop(context);
    _dialogOk(context, orderTime, false);
  }

  void _dialogOk(BuildContext context, OrderTime orderTime, bool cartClear) async {
    // user Date 변경
    DateTime changedOrderDate = model.viewUserOrderDate;
    model.changeUserOrderDate(changedOrderDate);
    model.changeUserOrderTime(orderTime);

    OrderModel orderModel = context.read();
    DeliverySiteModel deliverySiteModel = context.read();
    DeliveryDetailSiteModel detailSiteModel = context.read();

    orderModel.clear(notify: false);
    await orderModel.fetchAll(
      dIdx: deliverySiteModel.userDeliverySite?.idx,
      ddIdx: detailSiteModel.userDeliveryDetailSite?.idx,
      otIdx: orderTime?.idx,
      oDate: changedOrderDate,
      isForceUpdate: true
    );

    if(onSelected != null) {
      onSelected();
    }
  }
}
