import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OrderViewContentReadyWidget extends StatefulWidget {

  final int boxNumber;
  final bool isRequirement;
  final String title;
  final String subtitle;
  final String subtitle2;

  OrderViewContentReadyWidget({
    this.boxNumber,
    this.isRequirement = false,
    this.title,
    this.subtitle,
    this.subtitle2
  });

  @override
  _OrderViewContentReadyWidgetState createState() => _OrderViewContentReadyWidgetState();
}

class _OrderViewContentReadyWidgetState extends State<OrderViewContentReadyWidget> {

  DateTime currentPressTime;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          iconWidget: Text('거절', style: TextStyle(fontSize: 16.0, color: Theme.of(Get.context).backgroundColor)),
          color: Theme.of(Get.context).primaryColor,
          onTap: () => print('거절!'),
        ),
      ],
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${widget.boxNumber}번', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Theme.of(context).primaryColor
                      )),
                      if(widget.isRequirement) SizedBox(width: 15),
                      if(widget.isRequirement) Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).textTheme.headline1.color,
                            width: 0.5
                          ),
                        ),
                        child: Text('요청사항', style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 12
                        )),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('${widget.title}', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.black
                  )),
                  SizedBox(height: 5),
                  Text('${widget.subtitle}', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                  )),
                  SizedBox(height: 5),
                  Text('${widget.subtitle2}', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                  ))
                ],
              ),
            ),
            GestureDetector(
              onTap: _onTap,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: Text('접수', style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTap() {
    DateTime now = DateTime.now();
    if (currentPressTime == null ||
        now.difference(currentPressTime) > Duration(seconds: 2)) {
      currentPressTime = now;
      Fluttertoast.showToast(msg: '접수하려면 한번 더 누르세요.', );
      return;
    }
    print('접수~');
    return;
  }

}
