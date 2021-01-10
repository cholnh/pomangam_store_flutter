import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/cash_receipt_type.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:provider/provider.dart';

class OrderViewContentReadyWidget extends StatefulWidget {

  final int idx;
  final int boxNumber;
  final bool hasRequirement;
  final bool hasSubItems;
  final String title;
  final String subtitle;
  final String subtitle2;
  final String cashReceipt;
  final CashReceiptType cashReceiptType;
  final String note;

  OrderViewContentReadyWidget({
    this.idx,
    this.boxNumber,
    this.hasRequirement = false,
    this.hasSubItems = false,
    this.title,
    this.subtitle,
    this.subtitle2,
    this.cashReceipt,
    this.cashReceiptType,
    this.note
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
          onTap: _onDisapproveTap,
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
                      if(widget.hasRequirement) SizedBox(width: 15),
                      if(widget.hasRequirement) Container(
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
                      if(widget.hasSubItems) SizedBox(width: 15),
                      if(widget.hasSubItems) Container(
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
                  Row(
                    children: [
                      Text('${widget.subtitle2}', style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                      )),
                      if(!widget.cashReceipt.isNullOrBlank) SizedBox(width: 10),
                      if(!widget.cashReceipt.isNullOrBlank) Container(
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
                  if(widget.note != null && widget.note.isNotEmpty) SizedBox(height: 5),
                  if(widget.note != null && widget.note.isNotEmpty) Text('비고: ${widget.note}', style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor
                  )),
                ],
              ),
            ),
            Consumer<OrderModel>(
              builder: (_, model, __) {
                bool isChanging = model.isOrderChanging(widget.idx);
                return GestureDetector(
                  onTap: isChanging
                    ? () {}
                    : _onApproveTap,
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(
                        child: isChanging
                        ? CupertinoActivityIndicator()
                        : Text('접수', style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                        )),
                      ),
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  void _onApproveTap() {
    DateTime now = DateTime.now();
    if (currentPressTime == null ||
        now.difference(currentPressTime) > Duration(seconds: 2)) {
      currentPressTime = now;
      Fluttertoast.showToast(msg: '접수하려면 한번 더 누르세요.');
      return;
    }
    context.read<OrderModel>().approve(
      sIdx: context.read<SignInModel>().ownerInfo.idxStore,
      oIdx: widget.idx
    );
    return;
  }

  void _onDisapproveTap() {
    final TextEditingController _controller = TextEditingController();
    DialogUtils.dialogYesOrNo(context, '거절 사유를 입력해주세요.',
      contents: _contents(_controller),
      height: 250,
      confirm: '전송',
      onConfirm: (_) {
        context.read<OrderModel>().disapprove(
          sIdx: context.read<SignInModel>().ownerInfo.idxStore,
          oIdx: widget.idx,
          reason: _controller.text
        );
      },
      cancel: '취소'
    );
  }

  Widget _contents(TextEditingController _controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey[100],
      height: 100,
      child: TextFormField(
          scrollPhysics: BouncingScrollPhysics(),
          controller: _controller,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(fontSize: 15, color: Colors.black),
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
          )
      ),
    );
  }
}
