import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/deliverysite/detail/delivery_detail_site_items_widget.dart';
import 'package:provider/provider.dart';

class DeliveryDetailSitePage extends StatefulWidget {

  final DeliverySite deliverySite;

  DeliveryDetailSitePage(this.deliverySite);

  @override
  _DeliveryDetailSitePageState createState() => _DeliveryDetailSitePageState();
}

class _DeliveryDetailSitePageState extends State<DeliveryDetailSitePage> {

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
  DeliveryDetailSiteModel detailSiteModel = context.read();
    await detailSiteModel.fetch(
      dIdx: widget.deliverySite.idx,
      forceUpdate: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliverySiteModel>(
        builder: (_, model, __) {
          return ModalProgressHUD(
            inAsyncCall: model.isChanging,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: BasicAppBar(
                title: '${widget.deliverySite.name} 상세위치',
                leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
                elevation: 1.0,
              ),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: DeliveryDetailSiteItemsWidget(deliverySite: widget.deliverySite)
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
