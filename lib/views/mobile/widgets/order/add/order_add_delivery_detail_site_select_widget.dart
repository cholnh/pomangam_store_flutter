import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/domains/deliverysite/detail/delivery_detail_site.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:provider/provider.dart';

class OrderAddDeliveryDetailSiteSelectWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DeliveryDetailSiteModel detailSiteModel = context.watch();
    if(detailSiteModel.isFetching) return CupertinoActivityIndicator();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.grey[100],
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _items(detailSiteModel),
          ),
        ),
      ),
    );
  }

  List<Widget> _items(DeliveryDetailSiteModel detailSiteModel) {
    List<Widget> items = List();
    for(int i=0; i<detailSiteModel.deliveryDetailSites.length; i++) {
      DeliveryDetailSite detailSite = detailSiteModel.deliveryDetailSites[i];
      items.add(GestureDetector(
        onTap: () {
          detailSiteModel.changeViewSelected(detailSite);
        },
        child: RadioListTile(
          title: Text('${detailSite.name}', style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
          value: detailSiteModel.viewSelected?.idx == detailSite.idx,
          groupValue: true,

        ),
      ));
    }
    return items;
  }
}
