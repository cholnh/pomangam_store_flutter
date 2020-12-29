import 'package:flutter/material.dart';

class HomeStoreInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width / 3);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: w,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 0.5,
                    color: Theme.of(context).dividerColor,
                  )
                )
              ),
              child: Column(
                children: [
                  Text('고객 별점', style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.subtitle2.color
                  )),
                  SizedBox(height: 25),
                  Icon(Icons.check_circle, size: 17, color: Theme.of(context).primaryColor),
                  SizedBox(height: 5),
                  Text('5.0', style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: w,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 0.5,
                    color: Theme.of(context).dividerColor,
                  )
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('고객 리뷰수', style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.subtitle2.color
                  )),
                  SizedBox(height: 25),
                  Icon(Icons.check_circle, size: 17, color: Colors.amberAccent),
                  SizedBox(height: 5),
                  Text('347', style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: w,
              child: Column(
                children: [
                  Text('오늘 주문수', style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.subtitle2.color
                  )),
                  SizedBox(height: 25),
                  Icon(Icons.check_circle, size: 17, color: Colors.blueAccent),
                  SizedBox(height: 5),
                  Text('21', style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
