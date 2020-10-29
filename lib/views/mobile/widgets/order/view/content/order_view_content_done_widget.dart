import 'package:flutter/material.dart';

class OrderViewContentDoneWidget extends StatelessWidget {

  final int boxNumber;
  final bool isRequirement;
  final String title;
  final String subtitle;
  final String subtitle2;
  final String status;

  OrderViewContentDoneWidget({
    this.boxNumber,
    this.isRequirement = false,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.status = '완료'
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
                    Text('$boxNumber번', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Theme.of(context).primaryColor
                    )),
                    if(isRequirement) SizedBox(width: 15),
                    if(isRequirement) Container(
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
          SizedBox(
            width: 80,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[500],
                borderRadius: BorderRadius.circular(50)
              ),
              child: Center(
                child: Text('$status', style: TextStyle(
                  color: Colors.white,
                  fontSize: status.length >= 3 ? 18 : 23,
                  fontWeight: FontWeight.bold
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
