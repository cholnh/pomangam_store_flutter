import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/home/category/home_category_widget.dart';
import 'package:pomangam/views/mobile/widgets/home/home_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/home/store_info/home_store_info_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HomeAppBar(
        backgroundColor: context.watch<StoreModel>().onOff == OrderOnOff.ON
          ? Theme.of(context).primaryColor
          : Colors.grey[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              HomeStoreInfoWidget(),
              CustomDivider(),
              HomeCategoryWidget(),
              CustomDivider(),
            ],
          )
        )
      )
    );
  }
}
