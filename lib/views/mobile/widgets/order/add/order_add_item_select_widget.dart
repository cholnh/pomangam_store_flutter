import 'package:flutter/material.dart';
import 'package:pomangam/domains/product/product.dart';
import 'package:pomangam/providers/product/product_model.dart';
import 'package:provider/provider.dart';

class OrderAddItemSelectWidget extends StatelessWidget {

  final TextEditingController controller;

  OrderAddItemSelectWidget({this.controller});

  @override
  Widget build(BuildContext context) {
    ProductModel productModel = context.watch();
    return Column(
      children: [
        Container(
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
                children: _items(productModel),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          color: Colors.grey[100],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              scrollPhysics: BouncingScrollPhysics(),
              controller: controller,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.number,
              maxLines: null,
              style: TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixText: '개',
              ),
              onEditingComplete: () {
                try {
                  String text = controller.text;
                  if(text == null || text.isEmpty) {
                    controller.text = '1';
                    return;
                  }
                  int n = int.parse(text);
                  if(n < 1) controller.text = '1';
                } catch(e) {
                  controller.text = '1';
                }
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _items(ProductModel productModel) {
    List<Widget> items = List();
    for(int i=0; i<productModel.products.length; i++) {
      Product product = productModel.products[i];
      items.add(GestureDetector(
        onTap: () {
          productModel.changeViewSelected(product);
        },
        child: RadioListTile(
          title: Text('${product.productInfo?.name ?? ''}', style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
          value: productModel.viewSelected?.idx == product.idx,
          groupValue: true,

        ),
      ));
    }
    return items;
  }
}
