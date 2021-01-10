import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/item/sub/order_item_sub_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:provider/provider.dart';

class OrderHistoryContentWidget extends StatelessWidget {

  final OrderResponse order;

  OrderHistoryContentWidget({this.order});

  @override
  Widget build(BuildContext context) {
    int sIdx = Get.context.read<SignInModel>().ownerInfo.idxStore;
    List<OrderItemResponse> storeItems = order.orderItems.where((item) => item.idxStore == sIdx).toList();
    bool hasRequirement = _hasRequirement(storeItems);
    bool hasSubItems = _hasSubItems(storeItems);
    bool hasCashReceipt = !order.cashReceipt.isNullOrBlank;

    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('#${order.idx} (${order.boxNumber}번)', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Theme.of(context).primaryColor
                        )),
                        if(hasRequirement) SizedBox(width: 15),
                        if(hasRequirement) Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).textTheme.headline1.color,
                                width: 0.5
                            ),
                          ),
                          child: Text('요청사항', style: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color,
                              fontSize: 12
                          )),
                        ),
                        if(hasSubItems) SizedBox(width: 15),
                        if(hasSubItems) Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).textTheme.headline1.color,
                                width: 0.5
                            ),
                          ),
                          child: Text('서브메뉴', style: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color,
                              fontSize: 12
                          )),
                        )
                      ],
                    ),
                    Text('${_type()}', style: TextStyle(
                      fontSize: 13,
                      color: _typeColor()
                    ))
                  ],
                ),
                SizedBox(height: 10),
                Text('${_title(storeItems)}', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.black
                )),
                SizedBox(height: 5),
                Text('${_subtitle()}', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                )),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('${_subtitle2()}', style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    )),
                    if(hasCashReceipt) SizedBox(width: 10),
                    if(hasCashReceipt) Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).textTheme.headline1.color,
                            width: 0.5
                        ),
                      ),
                      child: Text('현금영수증', style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 12
                      )),
                    ),
                  ],
                ),
                if(order.note != null && order.note.isNotEmpty) SizedBox(height: 5),
                if(order.note != null && order.note.isNotEmpty) Text('비고: ${order.note}', style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).primaryColor
                )),
              ],
            ),
          ),
        ],
      ),
    );
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

  String _type() {
    String nameType = '';
    switch(order.orderType) {
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
        nameType = '결제실패'; break;
      case OrderType.PAYMENT_READY:
        nameType = '결제대기'; break;
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        nameType = '주문대기'; break;
      case OrderType.DELIVERY_READY:
        nameType = '메뉴준비'; break;
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        nameType = '배달중'; break;
      case OrderType.DELIVERY_SUCCESS:
        nameType = '배달완료'; break;
      case OrderType.PAYMENT_CANCEL:
      case OrderType.PAYMENT_REFUND:
      case OrderType.ORDER_REFUSE:
      case OrderType.ORDER_CANCEL:
        nameType = '주문취소'; break;
      case OrderType.MISS_BY_DELIVERER:
      case OrderType.MISS_BY_STORE:
        nameType = '주문누락'; break;
      default:
        nameType = '알수없음'; break;
    }
    return nameType;
  }

  Color _typeColor() {
    Color color = Theme.of(Get.context).textTheme.headline1.color;
    switch(order.orderType) {
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.PAYMENT_READY:
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_READY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_SUCCESS:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.PAYMENT_CANCEL:
      case OrderType.PAYMENT_REFUND:
      case OrderType.ORDER_REFUSE:
      case OrderType.ORDER_CANCEL:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.MISS_BY_DELIVERER:
      case OrderType.MISS_BY_STORE:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      default:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
    }
    return color;
  }
}
