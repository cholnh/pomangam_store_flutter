import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/item/order_item_response.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/views/mobile/pages/order/detail/order_detail_page.dart';
import 'package:pomangam/views/mobile/pages/order/detail/order_detail_page_type.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_widget.dart';
import 'package:provider/provider.dart';

class OrderViewContentTotalWidget extends StatefulWidget {

  final int index;
  final List<OrderResponse> orders;
  final Set<String> times;

  OrderViewContentTotalWidget({this.index, this.orders, this.times});

  @override
  _OrderViewContentTotalWidgetState createState() => _OrderViewContentTotalWidgetState();
}

class _OrderViewContentTotalWidgetState extends State<OrderViewContentTotalWidget> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: isExpanded
                            ? Colors.transparent
                            : Colors.grey[300],
                          width: 0.5
                      )
                  ),
                ),
                padding: EdgeInsets.only(top: widget.index == 0 ? 18 : 10, bottom: 18),
                child: Stack(
                  children: [
                    Center(
                      child: Text(_textTime(widget.times.elementAt(widget.index)), style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      )),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                          color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              if(isExpanded) Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('전체: ${totalCount()}개', style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )),
                    _totalItems()
                  ],
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            for(OrderResponse order in widget.orders)
              if(order.arrivalTime == widget.times.elementAt(widget.index))
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          context.read<OrderModel>().detail = order;
                          Get.to(OrderDetailPage(pageType: OrderDetailPageType.FROM_VIEW));
                        },
                        child: OrderViewContentWidget(order: order)
                    ),
                    CustomDivider()
                  ],
                ),
          ],
        )
      ],
    );
  }

  Widget _totalItems() {
    Map<String, int> map = Map();

    for(OrderResponse order in widget.orders) {
      if(order.arrivalTime == widget.times.elementAt(widget.index)) {
        for(OrderItemResponse item in order.orderItems) {
          map[item.nameProduct] = (map[item.nameProduct] ?? 0) + item.quantity;
        }
      }
    }
    //Text('포만: 32개');
    return Column(
      children: [
        for(String nameProduct in map.keys)
          Text('$nameProduct: ${map[nameProduct]}개', style: TextStyle(
            color: Colors.black,
            fontSize: 15
          ))
      ],
    );
  }

  int totalCount() {
    int totalCount = 0;
    for(OrderResponse order in widget.orders) {
      if(order.arrivalTime == widget.times.elementAt(widget.index)) {
        for(OrderItemResponse item in order.orderItems) {
          totalCount += item.quantity;
        }
      }
    }
    return totalCount;
  }

  void _onTap() {
    setState(() {
      this.isExpanded = !this.isExpanded;
    });
  }

  String _textTime(String time) {
    String h = time.split(':')[0];
    String m = time.split(':')[1];
    return '$h시' + (m == '00' ? '' : ' $m분');
  }
}
