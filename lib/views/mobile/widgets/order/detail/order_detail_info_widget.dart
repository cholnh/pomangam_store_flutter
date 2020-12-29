import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailInfoWidget extends StatelessWidget {

  final OrderResponse order;

  OrderDetailInfoWidget({this.order});

  @override
  Widget build(BuildContext context) {
    double height = 15;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주문정보', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black
          )),
          const SizedBox(height: 25),
          _text(
              leftText: '주문번호',
              rightText: 'no.${order.idx}'
          ),
          SizedBox(height: height),
          _text(
              leftText: '식별번호',
              rightText: '${order.boxNumber}번'
          ),
          SizedBox(height: height),
          if(order.ordererName != null) _text(
              leftText: '성함',
              rightText: '${order.ordererName}'
          ),
          if(order.ordererName != null) SizedBox(height: height),
          if(order.ordererPn != null) _text(
              leftText: '전화번호',
              rightText: '${order.ordererPn}',
              onRightTap: () async {
                if(!kIsWeb) {
                  String tel = 'tel:${order.ordererPn}';
                  if (await canLaunch(tel)) {
                    await launch(tel);
                  } else {
                    throw 'Could not launch $tel';
                  }
                }
              }
          ),
          if(order.ordererPn != null) SizedBox(height: height),
          _text(
              leftText: '승인일시',
              rightText: '${_date(order.registerDate)}'
          ),
          SizedBox(height: height),
          _text(
            leftText: '결제수단',
            rightText: '${convertPaymentTypeToText(order.paymentType)}',
          ),
          SizedBox(height: height),
          _text(
              leftText: '받는장소',
              rightText: '${order.nameDeliverySite} ${order.nameDeliveryDetailSite}'
          ),
          SizedBox(height: height),
          _text(
              leftText: '받는시간',
              rightText: '${_textDate(order.orderDate)} ${_textTime(order)}'
          ),
          SizedBox(height: height),
        ],
      ),
    );
  }

  Widget _text({
    String leftText = '',
    String rightText = '',
    Color color,
    Function onRightTap
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(leftText, style: TextStyle(
              fontSize: 14,
              color: color == null ? Theme.of(Get.context).textTheme.subtitle2.color : color
          ), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onRightTap != null ? onRightTap : (){},
            child: Text(rightText, style: TextStyle(
                fontSize: 14,
                fontWeight: onRightTap != null ? FontWeight.bold : FontWeight.normal,
                decoration: onRightTap != null ? TextDecoration.underline : TextDecoration.none,
                color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
            )),
          ),
        ),
      ],
    );
  }

  String _textDate(DateTime dt) {
    String result = '';
    if(isSameDay(dt, DateTime.now())) {
      return '오늘';
    } else if(isSameDay(dt, DateTime.now().add(Duration(days: 1)))) {
      result = '내일 ';
    } else if(isSameDay(dt, DateTime.now().add(Duration(days: 2)))) {
      result = '모레 ';
    }
    String weekday;
    switch(dt.weekday) {
      case 1: weekday = '(월)'; break;
      case 2: weekday = '(화)'; break;
      case 3: weekday = '(수)'; break;
      case 4: weekday = '(목)'; break;
      case 5: weekday = '(금)'; break;
      case 6: weekday = '(토)'; break;
      case 7: weekday = '(일)'; break;
    }

    return result + DateFormat('MM/dd$weekday').format(dt);
  }

  String _textTime(OrderResponse order) {
    int h = int.tryParse(order.arrivalTime.split(':')[0]);
    int m = int.tryParse(order.arrivalTime.split(':')[1]);
    m += int.tryParse(order.additionalTime.split(':')[1]);
    if(m >= 60) {
      m -= 60;
      h += 1;
    }
    return '$h시' + (m == 0 ? '' : ' $m분');
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  String _date(DateTime dt) {
    return DateFormat('yyyy. MM. dd hh:mm:ss').format(dt);
  }
}
