import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTimePickerModalHeaderWidget extends StatelessWidget {

  final bool isOrderDateMode;
  final String textOrderDate;
  final Function onSelectedDatePicker;

  OrderTimePickerModalHeaderWidget({this.isOrderDateMode, this.textOrderDate, this.onSelectedDatePicker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectedDatePicker,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0, bottom: 25.0),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '시간선택',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1.color
                    )
                  ),
                  Text(isOrderDateMode ? '시간변경' : '날짜변경', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(Get.context).primaryColor, fontSize: 13.0))
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 5.0)),
              Text('$textOrderDate', style: TextStyle(fontSize: 14.0, color: Theme.of(context).textTheme.headline1.color))
            ],
          ),
        ),
      ),
    );
  }
}
