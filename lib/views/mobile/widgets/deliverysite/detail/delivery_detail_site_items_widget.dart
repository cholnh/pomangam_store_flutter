import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:pomangam/_bases/initalizer/initializer.dart';
import 'package:pomangam/_bases/util/toast_utils.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/pages/_bases/base_page.dart';
import 'package:provider/provider.dart';
import 'package:pomangam/domains/deliverysite/detail/delivery_detail_site.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomangam/_bases/key/shared_preference_key.dart' as s;

class DeliveryDetailSiteItemsWidget extends StatefulWidget {

  final DeliverySite deliverySite;

  DeliveryDetailSiteItemsWidget({this.deliverySite});

  @override
  _DeliveryDetailSiteItemsWidgetState createState() => _DeliveryDetailSiteItemsWidgetState();
}

class _DeliveryDetailSiteItemsWidgetState extends State<DeliveryDetailSiteItemsWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryDetailSiteModel>(
      builder: (_, model, __) {
        if(model.isFetching) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        List<DeliveryDetailSite> detailSites = model.deliveryDetailSites;
        if(detailSites.length == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('배달 가능한 상세지역이 없습니다.', style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12.0)),
          );
        }
        return _items(detailSites);
      },
    );
  }

  Widget _items(List<DeliveryDetailSite> detailSites) {
    List<Widget> widgets = List();
    widgets.add(Column(
      children: <Widget>[
        Consumer<DeliveryDetailSiteModel>(
            builder: (_, model, __) {
              return GestureDetector(
                onTap: () => _change(null),
                child: Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.black, size: 15.0),
                        Padding(padding: const EdgeInsets.only(right: 17.0)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('전체', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Theme.of(context).textTheme.headline1.color)),
                              Icon(Icons.chevron_right, color: Theme.of(context).textTheme.headline1.color, size: 20)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
        Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5),
      ],
    ));
    detailSites.forEach((detailSite) {
      widgets.add(Column(
        children: <Widget>[
          _item(detailSite),
          Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5),
        ],
      ));
    });
    return Column(
      children: widgets
    );
  }

  Widget _item(DeliveryDetailSite detailSite) {
    String title = detailSite.name;
    return GestureDetector(
      onTap: () => _change(detailSite),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: <Widget>[
              Icon(Icons.location_on, color: Colors.black, size: 15.0),
              Padding(padding: const EdgeInsets.only(right: 17.0)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Theme.of(context).textTheme.headline1.color)),
                    Icon(Icons.chevron_right, color: Theme.of(context).textTheme.headline1.color, size: 20)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _change(DeliveryDetailSite detailSite) async {
    DeliverySiteModel deliverySiteModel = context.read();
    DeliveryDetailSiteModel detailSiteModel = context.read();

    try {
      deliverySiteModel.changeIsChanging(true);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setInt(s.idxDeliverySite, widget.deliverySite?.idx);
      await pref.setInt(s.idxDeliveryDetailSite, detailSite?.idx);

      deliverySiteModel.changeUserDeliverySite(widget.deliverySite);
      detailSiteModel.changeUserDeliveryDetailSite(detailSite);

      Initializer _initializer = Get.find<Initializer>(tag: 'initializer');
      await _initializer.initializeModelData();

      OrderModel orderModel = context.read();
      OrderTimeModel orderTimeModel = context.read();
      orderModel.clear(notify: false);
      await orderModel.fetchAll(
          dIdx: widget.deliverySite?.idx,
          ddIdx: detailSite?.idx,
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
