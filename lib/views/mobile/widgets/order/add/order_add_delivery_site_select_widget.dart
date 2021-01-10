import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:provider/provider.dart';

class OrderAddDeliverySiteSelectWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DeliverySiteModel deliverySiteModel = context.watch();
    if(deliverySiteModel.isFetching) return CupertinoActivityIndicator();
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
            children: _items(deliverySiteModel),
          ),
        ),
      ),
    );
  }

  List<Widget> _items(DeliverySiteModel deliverySiteModel) {
    List<Widget> items = List();
    for(int i=0; i<deliverySiteModel.deliverySites.length; i++) {
      DeliverySite dsite = deliverySiteModel.deliverySites[i];
      items.add(GestureDetector(
        onTap: () {
          deliverySiteModel.changeViewSelected(dsite);
        },
        child: RadioListTile(
          title: Text('${dsite.name}', style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
          value: deliverySiteModel.viewSelected?.idx == dsite.idx,
          groupValue: true,

        ),
      ));
    }
    return items;
  }
}
