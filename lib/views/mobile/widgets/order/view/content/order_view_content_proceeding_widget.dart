import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class OrderViewContentProceedingWidget extends StatelessWidget {

  final int idx;
  final int boxNumber;
  final bool hasRequirement;
  final bool hasSubItems;
  final String title;
  final String subtitle;
  final String subtitle2;
  final DateTime orderDate;
  final DateTime pickUpTime;
  final CountDownController _controller = CountDownController();

  OrderViewContentProceedingWidget({
    this.idx,
    this.boxNumber,
    this.hasRequirement = false,
    this.hasSubItems = false,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.orderDate,
    this.pickUpTime
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Text('${boxNumber}번', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Theme.of(context).primaryColor
                    )),
                    if(hasRequirement) SizedBox(width: 15),
                    if(hasRequirement) Container(
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
                    ),
                    if(hasSubItems) SizedBox(width: 15),
                    if(hasSubItems) Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).textTheme.headline1.color,
                            width: 0.5
                        ),
                      ),
                      child: Text('서브메뉴', style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 12
                      )),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text('$title', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.black
                )),
                SizedBox(height: 5),
                Text('$subtitle', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                )),
                SizedBox(height: 5),
                Text('$subtitle2', style: TextStyle(
                    fontSize: 15,
                    color: Colors.black
                ))
              ],
            ),
          ),
          CircularCountDownTimer(
            duration: _remainMinute(orderDate, pickUpTime),
            controller: _controller,
            width: 80,
            height: 80,
            color: Colors.grey[100],
            fillColor: Theme.of(context).primaryColor,
            backgroundColor: null,
            strokeWidth: 5.0,
            textStyle: TextStyle(fontSize: 23.0, color: Colors.black, fontWeight: FontWeight.bold),
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            onComplete: () {
            },
          )
        ],
      ),
    );
  }

  int _remainMinute(DateTime orderDate, DateTime pickUpTime) {
    if(orderDate == null || pickUpTime == null) return 0;
    DateTime pickUpDateTime = DateTime(orderDate.year, orderDate.month, orderDate.day, pickUpTime.hour, pickUpTime.minute, pickUpTime.second);
    DateTime now = DateTime.now();

    if(pickUpDateTime.isAfter(now)) {
      Duration diff = pickUpDateTime.difference(now);
      return diff.inSeconds;
    }
    return 0;
  }
}
