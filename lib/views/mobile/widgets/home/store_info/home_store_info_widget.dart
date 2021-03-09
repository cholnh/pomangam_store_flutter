import 'package:flutter/material.dart';
import 'package:pomangam/domains/store/store.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:provider/provider.dart';

class HomeStoreInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width / 3);
    Store storeInfo = context.watch<StoreModel>().storeInfo;

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
                  Text('${storeInfo.avgStar}', style: TextStyle(
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
                  Text('누적 주문수', style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.subtitle2.color
                  )),
                  SizedBox(height: 25),
                  Icon(Icons.check_circle, size: 17, color: Colors.blueAccent),
                  SizedBox(height: 5),
                  Text('${storeInfo.cntOrder}', style: TextStyle(
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
                  Text('${storeInfo.cntReview}', style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
