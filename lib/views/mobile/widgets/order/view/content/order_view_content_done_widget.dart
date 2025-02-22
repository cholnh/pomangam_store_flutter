import 'package:flutter/material.dart';
import 'package:pomangam/domains/order/cash_receipt_type.dart';

class OrderViewContentDoneWidget extends StatelessWidget {

  final int idx;
  final int boxNumber;
  final bool hasRequirement;
  final bool hasSubItems;
  final String title;
  final String subtitle;
  final String subtitle2;
  final String status;
  final String cashReceipt;
  final CashReceiptType cashReceiptType;
  final String note;

  OrderViewContentDoneWidget({
    this.idx,
    this.boxNumber,
    this.hasRequirement = false,
    this.hasSubItems = false,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.status = '완료',
    this.cashReceipt,
    this.cashReceiptType,
    this.note
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
                Row(
                  children: [
                    Text('$subtitle2', style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                    )),
                    if(cashReceipt != null && cashReceipt.isNotEmpty) SizedBox(width: 10),
                    if(cashReceipt != null && cashReceipt.isNotEmpty) Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).textTheme.headline1.color,
                            width: 0.5
                        ),
                      ),
                      child: Text('현금영수증', style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 12
                      )),
                    ),
                  ],
                ),
                if(note != null && note.isNotEmpty) SizedBox(height: 5),
                if(note != null && note.isNotEmpty) Text('비고: $note', style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor
                )),
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
