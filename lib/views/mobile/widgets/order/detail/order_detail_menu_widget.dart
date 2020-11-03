import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/item/sub/order_item_sub_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:provider/provider.dart';

class OrderDetailMenuWidget extends StatelessWidget {

  final OrderResponse order;

  OrderDetailMenuWidget({this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주문서', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline1.color
          )),
          SizedBox(height: 15),
          Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5, color: Colors.black),
          SizedBox(height: 10),
          _text(
              leftText: '메뉴명',
              centerText: '수량',
              rightText: '금액',
              color: Theme.of(Get.context).textTheme.subtitle2.color
          ),
          SizedBox(height: 10),
          Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5, color: Colors.black),
          SizedBox(height: 15),
          _items(),
          _text(
              leftText: '주문금액',
              rightText: '${StringUtils.comma(order.totalCost)}원',
              color: Theme.of(Get.context).textTheme.subtitle2.color
          ),
          SizedBox(height: 15),
          _text(
              leftText: '배달비',
              rightText: '+0원',
              color: Theme.of(Get.context).textTheme.subtitle2.color
          ),
          SizedBox(height: 15),
          _text(
            leftText: '할인금액',
            rightText: '-${StringUtils.comma(order.discountCost)}원',
            color: Theme.of(Get.context).textTheme.subtitle2.color
          ),
          SizedBox(height: 15),
          Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5, color: Colors.black),
          SizedBox(height: 15),
          _text(
            leftText: '합계',
            rightText: '${StringUtils.comma(order.paymentCost)}원',
            color: Theme.of(Get.context).textTheme.subtitle2.color
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  // Widget _text({
  //   String leftText = '',
  //   String centerText = '',
  //   String rightText = '',
  //   Color color
  // }) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(leftText, style: TextStyle(
  //           fontSize: 15,
  //           color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
  //       )),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Text(centerText, style: TextStyle(
  //               fontSize: 15,
  //               color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
  //           )),
  //           SizedBox(width: 40),
  //           Text(rightText, style: TextStyle(
  //               fontSize: 15,
  //               color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
  //           )),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _text({
    String leftText = '',
    String centerText = '',
    String rightText = '',
    Color color
  }) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(leftText, style: TextStyle(
              fontSize: 15,
              color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
          )),
        ),
        Expanded(
          flex: 1,
          child: Text(centerText, style: TextStyle(
              fontSize: 15,
              color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
          ), textAlign: TextAlign.end),
        ),
        Expanded(
          flex: 2,
          child: Text(rightText, style: TextStyle(
              fontSize: 15,
              color: color == null ? Theme.of(Get.context).textTheme.headline1.color : color
          ), textAlign: TextAlign.end),
        )
      ],
    );
  }

  Widget _items() {
    List<Widget> widgets = [];
    int sIdx = Get.context.read<SignInModel>().ownerInfo.idxStore;
    List<OrderItemResponse> orderItems = order.orderItems.where((item) => item.idxStore == sIdx).toList();

    widgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: orderItems.map((OrderItemResponse item) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<OrderModel>(
                  builder: (_, model, __) {
                    return GestureDetector(
                      onTap: () => model.orderItemToggle(item.idx),
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black,
                                            width: 0.5
                                        )
                                    ),
                                    child: item.isSelected
                                        ? Icon(Icons.check, size: 15)
                                        : null,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(item.nameProduct, style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(Get.context).textTheme.headline1.color,
                                      fontWeight: FontWeight.bold
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(item.quantity.toString(), style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(Get.context).textTheme.headline1.color
                              ), textAlign: TextAlign.end),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('${StringUtils.comma(item.saleCost)}', style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(Get.context).textTheme.headline1.color
                              ), textAlign: TextAlign.end),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
                SizedBox(height: 10),
                _subs(item),
                SizedBox(height: 15),
              ],
            );
          }).toList(),
        ),
        Divider(height: 0.5, thickness: kIsWeb ? 1.0 : 0.5, color: Colors.black),
        SizedBox(height: 15),
      ],
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets
    );
  }

  Widget _subs(OrderItemResponse item) {
    if(item.orderItemSubs.isEmpty && (item.requirement == null || item.requirement.isEmpty)) {
      return SizedBox(height: 0);
    }

    bool hasRequirement = item.requirement != null && item.requirement.isNotEmpty;

    List<Widget> widgets = [];
    for(int i=0; i<item.orderItemSubs.length; i++) {
      OrderItemSubResponse sub = item.orderItemSubs[i];
      widgets.add(Padding(
        padding: EdgeInsets.only(bottom: (i == item.orderItemSubs.length - 1 && !hasRequirement) ? 0 : 10),
        child: Consumer<OrderModel>(
            builder: (_, model, __) {
              return GestureDetector(
                onTap: () => model.orderSubItemToggle(sub.idx),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      width: 0.5
                                  )
                              ),
                              child: sub.isSelected
                                  ? Icon(Icons.check, size: 15)
                                  : null,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('${sub.nameProductSub}', style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(Get.context).textTheme.headline1.color
                              ))
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${sub.quantity}', style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(Get.context).textTheme.headline1.color
                        ), textAlign: TextAlign.end)
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${StringUtils.comma(sub.saleCost)}', style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(Get.context).textTheme.headline1.color
                        ), textAlign: TextAlign.end)
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ));
    }
    if(hasRequirement) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(Get.context).primaryColor,
                      width: 0.5
                  )
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text('요청사항', style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(Get.context).primaryColor,
              )),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text('${item.requirement}', style: TextStyle(
                fontSize: 15.0,
                color: Theme.of(Get.context).textTheme.headline1.color
              ))
            ),
          ],
        ),
      ));
    }
    // widgets.add(Padding(padding: const EdgeInsets.only(bottom: 15)));
    return Container(
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.grey[200],
            width: 5.0
          )
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets
      ),
    );
  }
}
