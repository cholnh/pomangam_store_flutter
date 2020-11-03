import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/order/detail/order_detail_info_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/detail/order_detail_menu_widget.dart';

class OrderDetailPage extends StatelessWidget {

  final OrderResponse order;

  OrderDetailPage({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: BasicAppBar(
        title: '${order.boxNumber}번 주문상세',
        leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
        elevation: 1.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              OrderDetailMenuWidget(order: order),
              CustomDivider(),
              OrderDetailInfoWidget(order: order),
              CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
