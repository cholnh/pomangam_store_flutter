import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/util/toast_utils.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/pages/_bases/base_page.dart';
import 'package:pomangam/views/mobile/pages/deliverysite/detail/delivery_detail_site_page.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;
import 'package:shared_preferences/shared_preferences.dart';

class DeliverySiteSearchHistoryWidget extends StatefulWidget {

  final bool isFirst;

  DeliverySiteSearchHistoryWidget({this.isFirst});

  @override
  _DeliverySiteSearchHistoryWidgetState createState() => _DeliverySiteSearchHistoryWidgetState();
}

class _DeliverySiteSearchHistoryWidgetState extends State<DeliverySiteSearchHistoryWidget> {

  @override
  void initState() {
    context.read<DeliverySiteModel>().fetch(forceUpdate: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliverySiteModel>(
      builder: (_, model, __) {
        if(model.isFetching || model.isSearching) return _loading();
        if(model.userDeliverySites.isEmpty) return _empty();
        return _items(model.userDeliverySites);
      },
    );
  }

  Widget _loading() {
    int r = Random().nextInt(10) + 1;
    return Container(
      color: Colors.white,
      child: Column(
        children: List.generate(r, (index) {
          int w = Random().nextInt(100) + 40;
          int w2 = Random().nextInt(200) + 50;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: <Widget>[
                    CustomShimmer(width: 18, height: 20),
                    const SizedBox(width: 17),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomShimmer(width: w.toDouble(), height: 20),
                          const SizedBox(height: 5),
                          CustomShimmer(width: w2.toDouble(), height: 15),
                        ],
                      ),
                    ),
                    CustomShimmer(width: 20, height: 20),
                  ],
                ),
              ),
              Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5)
            ],
          );
        })
      ),
    );
  }

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(child: Text('검색 결과가 없습니다.', style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12.0))),
    );
  }

  Widget _items(List<DeliverySite> deliverySites) {
    List<Widget> widgets = List();
    widgets.add(Column(
      children: <Widget>[
        _item(null),
        Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5)
      ],
    ));

    for(int i=0; i<deliverySites.length; i++) {
      DeliverySite deliverySite = deliverySites[i];

      widgets.add(Column(
        children: <Widget>[
          _item(deliverySite),
          Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5)
        ],
      ));
    }
    return Container(
      color: Colors.white,
      child: Column(children: widgets)
    );
  }

  Widget _item(DeliverySite deliverySite) {
    String title = deliverySite?.name ?? '전체';
    String subTitle = deliverySite?.location ?? '';

    return GestureDetector(
      onTap: () {
        // 키보드 hide
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();

        if(deliverySite == null) {
          _change();
        } else {
          Get.to(DeliveryDetailSitePage(deliverySite),
              transition: Transition.cupertino,
              duration: Duration.zero
          );
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: <Widget>[
              Icon(Icons.location_on, color: Theme.of(context).textTheme.headline1.color, size: 15.0),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Theme.of(context).textTheme.headline1.color), overflow: TextOverflow.visible),
                    if(!subTitle.isNullOrBlank) const SizedBox(height: 5),
                    if(!subTitle.isNullOrBlank) Text(subTitle, style: TextStyle(fontSize: 13.0, color: Colors.black.withOpacity(0.5)), overflow: TextOverflow.visible)
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).textTheme.headline1.color, size: 20)
            ],
          ),
        ),
      ),
    );
  }

  void _change() async {
    DeliverySiteModel deliverySiteModel = context.read();
    DeliveryDetailSiteModel detailSiteModel = context.read();

    try {
      deliverySiteModel.changeIsChanging(true);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setInt(s.idxDeliverySite, null);
      await pref.setInt(s.idxDeliveryDetailSite, null);

      deliverySiteModel.changeUserDeliverySite(null);
      detailSiteModel.changeUserDeliveryDetailSite(null);

      Initializer _initializer = Get.find<Initializer>(tag: 'initializer');
      await _initializer.initializeModelData();

      OrderModel orderModel = context.read();
      OrderTimeModel orderTimeModel = context.read();
      orderModel.clear(notify: false);
      await orderModel.fetchAll(
          dIdx: null,
          ddIdx: null,
          otIdx: null, //orderTimeModel.userOrderTime?.idx,
          oDate: orderTimeModel.userOrderDate,
          isForceUpdate: true
      );

      Get.offAll(BasePage(), transition: Transition.cupertino);

      ToastUtils.showToast(msg: '적용완료');
    } finally {
      deliverySiteModel.changeIsChanging(false);
    }
  }
}
