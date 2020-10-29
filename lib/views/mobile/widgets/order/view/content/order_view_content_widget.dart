import 'package:flutter/material.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_done_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_proceeding_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_ready_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderViewContentWidget extends StatelessWidget {

  final OrderResponse order;

  OrderViewContentWidget({this.order});

  @override
  Widget build(BuildContext context) {
    switch(order.orderType) {
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        return OrderViewContentReadyWidget(
          boxNumber: order.boxNumber,
          isRequirement: _isRequirement(order),
          title: _title(order),
          subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
          subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
        );

      case OrderType.DELIVERY_READY:
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        return OrderViewContentProceedingWidget(
          boxNumber: order.boxNumber,
          isRequirement: _isRequirement(order),
          title: _title(order),
          subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
          subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
          orderDate: order.orderDate,
          pickUpTime: context.watch<OrderTimeModel>().getPickUpTime(order.idxOrderTime),
        );

      case OrderType.DELIVERY_SUCCESS:
        return OrderViewContentDoneWidget(
            boxNumber: order.boxNumber,
            isRequirement: _isRequirement(order),
            title: _title(order),
            subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
            subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
            status: '기사누락'
        );

      case OrderType.MISS_BY_DELIVERER:
        return OrderViewContentDoneWidget(
            boxNumber: order.boxNumber,
            isRequirement: _isRequirement(order),
            title: _title(order),
            subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
            subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
            status: '기사누락'
        );
      case OrderType.MISS_BY_STORE:
        return OrderViewContentDoneWidget(
            boxNumber: order.boxNumber,
            isRequirement: _isRequirement(order),
            title: _title(order),
            subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
            subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
            status: '업체누락'
        );
      case OrderType.RE_DELIVERY:
        return OrderViewContentDoneWidget(
            boxNumber: order.boxNumber,
            isRequirement: _isRequirement(order),
            title: _title(order),
            subtitle: '${_textDate(order.orderDate)} ${_textTime(order)} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}',
            subtitle2: '${_payment(order.paymentType)} ${StringUtils.comma(order.paymentCost)}원',
            status: '재배달'
        );

      default: return Container();
    }
  }

  bool _isRequirement(OrderResponse order) {
    for(OrderItemResponse item in order.orderItems) {
      if(item.requirement != null && item.requirement.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
  String _title(OrderResponse order) {
    if(order.orderItems == null || order.orderItems.isEmpty) {
      return '오류';
    }
    if(order.orderItems.length == 1) {
      return '${order.orderItems.first.nameProduct}';
    } else {
      return '${order.orderItems.first.nameProduct} 외 ${order.orderItems.length - 1}개';
    }
  }

  String _payment(PaymentType paymentType) {
    switch(paymentType) {
      case PaymentType.CONTACT_CREDIT_CARD:
      case PaymentType.CONTACT_CASH:
        return '후불결제';
      case PaymentType.COMMON_CREDIT_CARD:
      case PaymentType.COMMON_PHONE:
      case PaymentType.COMMON_V_BANK:
      case PaymentType.COMMON_BANK:
        return '결제완료';
    }
    return '';
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
}
