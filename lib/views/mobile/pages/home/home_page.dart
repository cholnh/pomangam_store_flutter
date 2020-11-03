import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/views/mobile/widgets/home/home_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        backgroundColor: context.watch<OrderModel>().onOff == OrderOnOff.ON
          ? Theme.of(context).primaryColor
          : Colors.grey[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          )
        )
      )
    );
  }
}
