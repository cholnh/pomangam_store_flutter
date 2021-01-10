import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/item/sub/order_item_sub_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_done_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_proceeding_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_ready_widget.dart';
import 'package:provider/provider.dart';

class OrderViewContentWidget extends StatelessWidget {

  final OrderResponse order;

  OrderViewContentWidget({this.order});

  @override
  Widget build(BuildContext context) {
    int sIdx = Get.context.read<SignInModel>().ownerInfo.idxStore;
    List<OrderItemResponse> storeItems = order.orderItems.where((item) => item.idxStore == sIdx).toList();

    switch(order.orderType) {
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        return OrderViewContentReadyWidget(
          idx: order.idx,
          boxNumber: order.boxNumber,
          hasRequirement: _hasRequirement(storeItems),
          hasSubItems: _hasSubItems(storeItems),
          title: _title(storeItems),
          subtitle: _subtitle(),
          subtitle2: _subtitle2(),
          cashReceipt: order.cashReceipt,
          cashReceiptType: order.cashReceiptType,
          note: order.note
        );

      case OrderType.DELIVERY_READY:
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        return OrderViewContentProceedingWidget(
          idx: order.idx,
          boxNumber: order.boxNumber,
          hasRequirement: _hasRequirement(storeItems),
          hasSubItems: _hasSubItems(storeItems),
          title: _title(storeItems),
          subtitle: _subtitle(),
          subtitle2: _subtitle2(),
          orderDate: order.orderDate,
          pickUpTime: context.watch<OrderTimeModel>().getPickUpTime(order.idxOrderTime),
          cashReceipt: order.cashReceipt,
          cashReceiptType: order.cashReceiptType,
          note: order.note
        );

      case OrderType.DELIVERY_SUCCESS:
        return OrderViewContentDoneWidget(
            idx: order.idx,
            boxNumber: order.boxNumber,
            hasRequirement: _hasRequirement(storeItems),
            hasSubItems: _hasSubItems(storeItems),
            title: _title(storeItems),
            subtitle: _subtitle(),
            subtitle2: _subtitle2(),
            cashReceipt: order.cashReceipt,
            cashReceiptType: order.cashReceiptType,
            note: order.note
        );

      case OrderType.MISS_BY_DELIVERER:
        return OrderViewContentDoneWidget(
            idx: order.idx,
            boxNumber: order.boxNumber,
            hasRequirement: _hasRequirement(storeItems),
            hasSubItems: _hasSubItems(storeItems),
            title: _title(storeItems),
            subtitle: _subtitle(),
            subtitle2: _subtitle2(),
            status: '기사누락',
            cashReceipt: order.cashReceipt,
            cashReceiptType: order.cashReceiptType,
            note: order.note
        );
      case OrderType.MISS_BY_STORE:
        return OrderViewContentDoneWidget(
            idx: order.idx,
            boxNumber: order.boxNumber,
            hasRequirement: _hasRequirement(storeItems),
            hasSubItems: _hasSubItems(storeItems),
            title: _title(storeItems),
            subtitle: _subtitle(),
            subtitle2: _subtitle2(),
            status: '업체누락',
            cashReceipt: order.cashReceipt,
            cashReceiptType: order.cashReceiptType,
            note: order.note
        );
      case OrderType.RE_DELIVERY:
        return OrderViewContentDoneWidget(
            idx: order.idx,
            boxNumber: order.boxNumber,
            hasRequirement: _hasRequirement(storeItems),
            hasSubItems: _hasSubItems(storeItems),
            title: _title(storeItems),
            subtitle: _subtitle(),
            subtitle2: _subtitle2(),
            status: '재배달',
            cashReceipt: order.cashReceipt,
            cashReceiptType: order.cashReceiptType,
            note: order.note
        );

      default: return Container();
    }
  }

  bool _hasRequirement(List<OrderItemResponse> storeItems) {
    for(OrderItemResponse item in storeItems) {
      if(item.requirement != null && item.requirement.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  bool _hasSubItems(List<OrderItemResponse> storeItems) {
    for(OrderItemResponse item in storeItems) {
      if(item.orderItemSubs.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  String _title(List<OrderItemResponse> storeItems) {
    if(storeItems == null || storeItems.isEmpty) return '오류';

    if(storeItems.length == 1) {
      return '${storeItems.first.nameProduct}' + (storeItems.first.quantity == 1 ? '' : ' ${storeItems.first.quantity}개');
    } else {
      return '${storeItems.first.nameProduct} 외 ${storeItems.length - 1}개';
    }
  }

  String _payment() {
    switch(order.paymentType) {
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

  String _textDate() {
    String result = '';
    DateTime dt = order.orderDate;
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

  String _textTime() {
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

  String _subtitle() {
    return '${_textDate()} ${_textTime()} ${order.nameDeliverySite} ${order.nameDeliveryDetailSite}';
  }

  String _subtitle2() {
    return '${_payment()} ${StringUtils.comma(_storeTotalPrice() - order.discountCost)}원';
  }

  int _storeTotalPrice() {
    int total = 0;
    int sIdx = Get.context.read<SignInModel>().ownerInfo.idxStore;
    for(OrderItemResponse item in order.orderItems) {
      if(item.idxStore == sIdx) {
        total += item.saleCost * item.quantity;
        for(OrderItemSubResponse sub in item.orderItemSubs) {
          total += sub.saleCost * item.quantity;
        }
      }
    }
    return total;
  }
}
