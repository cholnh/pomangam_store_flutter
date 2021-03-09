import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:provider/provider.dart';
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
          if(!order.ordererPn.isNullOrBlank || !order.phoneNumber.isNullOrBlank) _text(
              leftText: '전화번호',
              rightText: !order.ordererPn.isNullOrBlank ? '${order.ordererPn}' : '${order.phoneNumber}',
              rightUnderline: true,
              onRightTap: () async {
                if(!kIsWeb) {
                  String tel = 'tel:${!order.ordererPn.isNullOrBlank ? order.ordererPn : order.phoneNumber}';
                  if (await canLaunch(tel)) {
                    await launch(tel);
                  } else {
                    throw 'Could not launch $tel';
                  }
                }
              }
          ),
          if(!order.ordererPn.isNullOrBlank || !order.phoneNumber.isNullOrBlank) SizedBox(height: height),
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
          _text(
            leftText: '비고',
            rightText: order.note.isNullOrBlank
              ? '작성하기'
              : '${order.note}',
            rightUnderline: order.note.isNullOrBlank,
            color: Theme.of(context).primaryColor,
            onRightTap: () => _writeNote()
          ),
        ],
      ),
    );
  }

  void _writeNote() {
    final TextEditingController _controller = TextEditingController();
    _controller.text = order.note.isNullOrBlank ? '' : order.note;
    DialogUtils.dialogYesOrNo(Get.context, '간단한 메모를 입력해주세요.',
        contents: _contents(_controller),
        height: 250,
        confirm: '저장',
        onConfirm: (_) async {
          if(_controller.text != order.note) {
            Get.context.read<OrderModel>().patchNote(
              sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
              oIdx: order.idx,
              note: _controller.text
            );
          }
        },
        cancel: '취소'
    );
  }

  Widget _contents(TextEditingController _controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey[100],
      height: 100,
      child: TextFormField(
          scrollPhysics: BouncingScrollPhysics(),
          controller: _controller,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(fontSize: 15, color: Colors.black),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          )
      ),
    );
  }

  Widget _text({
    String leftText = '',
    String rightText = '',
    Color color,
    bool rightUnderline = false,
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
                decoration: rightUnderline ? TextDecoration.underline : TextDecoration.none,
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
