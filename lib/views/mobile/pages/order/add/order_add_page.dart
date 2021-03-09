import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/_bases/util/toast_utils.dart';
import 'package:pomangam/domains/deliverysite/delivery_site.dart';
import 'package:pomangam/domains/order/item/order_item_request.dart';
import 'package:pomangam/domains/order/order_request.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/time/order_time.dart';
import 'package:pomangam/domains/payment/cash_receipt/cash_receipt_type.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/domains/product/product.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/providers/payment/payment_model.dart';
import 'package:pomangam/providers/product/product_model.dart';
import 'package:pomangam/providers/promotion/promotion_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/order/add/order_add_delivery_detail_site_select_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/add/order_add_delivery_site_select_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/add/order_add_item_select_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/add/order_add_order_datetime_select_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/add/order_add_payment_method_select_widget.dart';
import 'package:provider/provider.dart';

class OrderAddPage extends StatefulWidget {
  @override
  _OrderAddPageState createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {

  // 비고
  String note = '관리자 수동 주문';
  // 제품내역
  List<OrderItemRequest> items = List();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    this.items.clear();
    context.read<ProductModel>().fetch(
      sIdx: context.read<SignInModel>().ownerInfo.idxStore
    );
    context.read<PaymentModel>()
      ..selectedCashReceipt = null
      ..viewSelectedCashReceipt = null;

    context.read<OrderTimeModel>()
      ..selectedOrderDate2 = null
      ..viewSelectedOrderDate2 = null;

    context.read<PromotionModel>().clear(notify: false);
  }

  @override
  Widget build(BuildContext context) {
    final double height = 25;
    DeliverySiteModel deliverySiteModel = context.watch();
    DeliveryDetailSiteModel detailSiteModel = context.watch();
    OrderTimeModel orderTimeModel = context.watch();
    PaymentModel paymentModel = context.watch();
    PromotionModel promotionModel = context.watch();

    int promotionCost = 0;
    promotionModel.promotions.forEach((promotion) {
      if(promotion.isValid()) {
        promotionCost += promotion.discountCost;
      }
    });

    int totalQuantity = 0;
    int totalCost = 0;
    items.forEach((item) {
      totalQuantity += item.quantity;
      totalCost += (item.salesCost - promotionCost) * item.quantity;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _bottom(totalCost: totalCost),
      appBar: BasicAppBar(
        elevation: 1.0,
        title: '주문 추가',
        leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('주문정보', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )),
                    SizedBox(height: height),
                    _text(
                      leftText: '받는 장소',
                      rightText: deliverySiteModel.selected.isNull ? '선택해주세요' : '${deliverySiteModel?.selected?.name ?? ''} ${detailSiteModel?.selected?.name ?? ''}',
                      onRightTap: _selectDeliverySite
                    ),
                    SizedBox(height: height),
                    _text(
                      leftText: '받는 날짜',
                      rightText: deliverySiteModel.selected.isNull
                        ? '선택해주세요'
                        : '${DateFormat('yyyy-MM-dd').format(orderTimeModel.selectedOrderDate == null ? DateTime.now() : orderTimeModel.selectedOrderDate)} ' +
                          (orderTimeModel.selectedOrderDate2 == null ? '' : '~ ${DateFormat('yyyy-MM-dd').format(orderTimeModel.selectedOrderDate2)}\n')+
                          '${_textOrderTime(orderTimeModel.selected)}',
                      onRightTap: _selectOrderDateTime
                    ),
                    SizedBox(height: height),
                    _text(
                      leftText: '결제 방식',
                      rightText: '${convertPaymentTypeToText(paymentModel.selectedPaymentType)}',
                      onRightTap: _selectPaymentMethod
                    ),
                    SizedBox(height: height),
                    // _text(
                    //     leftText: '현금영수증',
                    //     rightText: paymentModel.selectedCashReceipt == null
                    //       ? '선택 안 함'
                    //       : '${convertCashReceiptTypeToShortText(paymentModel.selectedCashReceipt.cashReceiptType)} ${paymentModel.selectedCashReceipt.cashReceiptNumber}'
                    // ),
                    // SizedBox(height: height),
                    _text(
                        leftText: '비고',
                        rightText: '${this.note ?? ''}',
                        onRightTap: _writeNote
                    ),
                  ],
                ),
              ),
              CustomDivider(),
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text('제품내역', style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )),
                            if(!promotionModel.promotions.isNullOrBlank) SizedBox(width: 10),
                            if(!promotionModel.promotions.isNullOrBlank) Text('프로모션 적용중 (${StringUtils.comma(promotionCost)}원)', style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).textTheme.subtitle2.color
                            )),
                          ],
                        ),
                        Text('총 $totalQuantity개', style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.subtitle2.color
                        )),
                      ],
                    ),
                    SizedBox(height: height),
                    for(int i=0; i<items.length; i++)
                      _item(i, items[i], promotionCost: promotionCost),
                    GestureDetector(
                      onTap: _addItem,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 18, color: Theme.of(context).textTheme.subtitle2.color),
                          SizedBox(width: 10),
                          Text('눌러서 제품 추가하기', style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color,
                            fontSize: 15
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CustomDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int i, OrderItemRequest item, {int promotionCost = 0}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text('${i+1}. ${item.textProduct} (${StringUtils.comma((item.salesCost - promotionCost) * item.quantity)}원)', style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.headline1.color
              )),
            ),
            Row(
              children: [
                Text('${item.quantity}개', style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.subtitle2.color
                )),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      items.removeWhere((node) => node.index == item.index);
                    });
                  },
                  child: Icon(Icons.highlight_remove, size: 20, color: Colors.black)
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _text({
    String leftText = '',
    String rightText = '',
    Function onRightTap,
    Color rightColor = Colors.black
  }) {
    return GestureDetector(
      onTap: onRightTap != null ? onRightTap : (){},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(leftText, style: TextStyle(
                fontSize: 15,
                color: Theme.of(Get.context).textTheme.subtitle2.color
            )),
          ),
          Expanded(
            child: Text(rightText, style: TextStyle(
                fontSize: 15,
                color: rightColor
            )),
          ),
          SizedBox(
              width: 15,
              child: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black)
          ),
        ],
      ),
    );
  }

  Widget _bottom({int totalCost = 0}) {
    return Consumer<OrderModel>(
      builder: (_, model, __) {
        return GestureDetector(
          onTap: model.isSaving ? (){} : _save,
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                color: Theme.of(Get.context).backgroundColor,
                border: Border.all(
                    color: Theme.of(Get.context).dividerColor,
                    width: 0.5
                )
            ),
            child: Center(
              child: model.isSaving ? CupertinoActivityIndicator() : Text('추가' + (totalCost != 0 ? ' (${StringUtils.comma(totalCost)}원)' : ''), style: TextStyle(
                  color: Theme.of(Get.context).primaryColor,
                  fontSize: 17
              )),
            ),
          ),
        );
      },
    );
  }

  void _writeNote() {
    final TextEditingController _controller = TextEditingController();
    _controller.text = this.note.isNullOrBlank ? '' : this.note;
    DialogUtils.dialogYesOrNo(Get.context, '간단한 메모를 입력해주세요.',
        contents: Container(
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
        ),
        height: 250,
        confirm: '완료',
        onConfirm: (_) async {
          setState(() {
            this.note = _controller.text;
          });
        },
        cancel: '취소'
    );
  }

  void _selectDeliverySite() {
    DeliverySiteModel deliverySiteModel = context.read();
    deliverySiteModel.viewSelected = deliverySiteModel.selected;
    deliverySiteModel
      //..clear()
      ..fetch(forceUpdate: true);
    DialogUtils.dialogYesOrNo(Get.context, '받는 장소를 선택해주세요.',
        contents: OrderAddDeliverySiteSelectWidget(),
        height: 350,
        confirm: '다음',
        onConfirm: (_) async {
          _selectDeliveryDetailSite();
        },
        cancel: '취소'
    );
  }

  void _selectDeliveryDetailSite() {
    DeliverySite viewSelected = context.read<DeliverySiteModel>().viewSelected;
    if(viewSelected != null) {
      DeliveryDetailSiteModel detailSiteModel = context.read();
      detailSiteModel.viewSelected = null;
      detailSiteModel
      //..clear()
        ..fetch(dIdx: viewSelected.idx, forceUpdate: true);

      DialogUtils.dialogYesOrNo(Get.context, '세부 장소를 선택해주세요.',
          contents: OrderAddDeliveryDetailSiteSelectWidget(),
          height: 350,
          confirm: '완료',
          onConfirm: (_) async {
            if(detailSiteModel.viewSelected != null) {
              DeliverySiteModel deliverySiteModel = context.read();
              deliverySiteModel.changeSelected(deliverySiteModel.viewSelected);
              detailSiteModel.changeSelected(detailSiteModel.viewSelected);

              OrderTimeModel orderTimeModel = context.read();
              await orderTimeModel.fetch(
                  dIdx: deliverySiteModel.selected.idx, forceUpdate: true);
              orderTimeModel.selectedOrderDate = DateTime.now();
              orderTimeModel.selected =
              orderTimeModel.orderTimes.isNullOrBlank ? null : orderTimeModel
                  .orderTimes.first;

              context.read<PromotionModel>().fetchByIdxDeliverySite(
                  dIdx: context
                      .read<DeliverySiteModel>()
                      .selected
                      .idx
              );
            }
          },
          cancel: '취소'
      );
    }
  }

  void _selectOrderDateTime() {
    DeliverySiteModel deliverySiteModel = context.read();
    if(deliverySiteModel.selected == null) {
      DialogUtils.dialog(context, '받는 장소를 먼저 선택해주세요.');
      return;
    }
    OrderTimeModel orderTimeModel = context.read();
    orderTimeModel.viewSelected = orderTimeModel.selected;
    orderTimeModel.viewSelectedOrderDate = orderTimeModel.selectedOrderDate;
    orderTimeModel.viewSelectedOrderDate2 = orderTimeModel.selectedOrderDate2;
    // orderTimeModel
    //..clear()
    //..fetch(dIdx: deliverySiteModel.selected.idx, forceUpdate: true);
    DialogUtils.dialogYesOrNo(Get.context, '받는 날짜를 선택해주세요.',
        contents: OrderAddOrderDateTimeSelectWidget(),
        height: 510,
        confirm: '완료',
        onConfirm: (_) async {
          if(orderTimeModel.viewSelected == null) return;
          orderTimeModel
            ..changeSelected(orderTimeModel.viewSelected)
            ..changeSelectedOrderDate(orderTimeModel.viewSelectedOrderDate)
            ..changeSelectedOrderDate2(orderTimeModel.viewSelectedOrderDate2);
        },
        cancel: '취소'
    );
  }

  void _selectPaymentMethod() {
    PaymentModel paymentModel = context.read();
    paymentModel.viewSelectedPaymentType = paymentModel.selectedPaymentType;

    DialogUtils.dialogYesOrNo(Get.context, '결제 방식을 선택해주세요.',
        contents: OrderAddPaymentMethodSelectWidget(),
        height: 350,
        confirm: '완료',
        onConfirm: (_) async {
          paymentModel.changeSelectedPaymentType(paymentModel.viewSelectedPaymentType);
        },
        cancel: '취소'
    );
  }

  String _textOrderTime(OrderTime ot) {
    if(ot == null) return '';
    DateTime dt = ot.getArrivalDateTime();
    DateFormat formatter = DateFormat('a');
    String ampm = formatter.format(dt).toUpperCase() == 'PM' ? '오후' : '오전';
    return DateFormat('$ampm hh시 mm분').format(dt);
  }


  void _addItem() {
    ProductModel productModel = context.read();
    final TextEditingController controller = TextEditingController();
    controller.text = '1';

    DialogUtils.dialogYesOrNo(Get.context, '제품 추가',
        contents: OrderAddItemSelectWidget(controller: controller),
        height: 450,
        confirm: '추가',
        onConfirm: (_) async {
          int q = int.tryParse(controller.text) ?? 0;
          if(productModel.viewSelected == null || q < 1) return;
          setState(() {
            Product selected = productModel.viewSelected;
            items.add(OrderItemRequest(
              idxStore: selected.idxStore,
              idxProduct: selected.idx,
              quantity: int.parse(controller.text),
              textProduct: selected.productInfo.name,
              orderItemSubs: [],
              index: items.isNullOrBlank ? 0 : items.last.index + 1,
              salesCost: selected.salePrice
            ));
            productModel.viewSelected = null;
          });
        },
        cancel: '취소'
    );
  }

  void _save() async {
    if(context.read<OrderTimeModel>().selectedOrderDate == null) {
      ToastUtils.showToast(msg: '받는 날짜를 선택해주세요.');
      return;
    }
    if(context.read<OrderTimeModel>().selected == null) {
      ToastUtils.showToast(msg: '받는 시간을 선택해주세요.');
      return;
    }
    if(context.read<DeliveryDetailSiteModel>().selected == null) {
      ToastUtils.showToast(msg: '받는 장소를 선택해주세요.');
      return;
    }
    if(context.read<PaymentModel>().selectedPaymentType == null) {
      ToastUtils.showToast(msg: '결제 방식을 선택해주세요.');
      return;
    }
    if(this.items.isEmpty) {
      ToastUtils.showToast(msg: '제품을 추가해주세요.');
      return;
    }

    if(context.read<OrderTimeModel>().selectedOrderDate2 != null) {
      DateTime dt1 = DateTime(context.read<OrderTimeModel>().selectedOrderDate.year, context.read<OrderTimeModel>().selectedOrderDate.month, context.read<OrderTimeModel>().selectedOrderDate.day);
      DateTime dt2 = DateTime(context.read<OrderTimeModel>().selectedOrderDate2.year, context.read<OrderTimeModel>().selectedOrderDate2.month, context.read<OrderTimeModel>().selectedOrderDate2.day);

      int d = dt2.difference(dt1).inDays;
      DialogUtils.dialogYesOrNo(context,
        '총 $d개의 주문이 추가됩니다.\n계속 하시겠습니까?\n( ${DateFormat('MM월 dd일').format(dt1)} ~ ${DateFormat('MM월 dd일').format(dt2)} )',
        height: 180,
        onConfirm: (_) async {
          context.read<OrderModel>().changeIsSaving(true);
          DateTime start = dt1;
          for(int i = 0; i<=d; i++) {
            OrderResponse response = await _saveOrder(start);
            if(response == null) {
              ToastUtils.showToast(msg: '주문 추가 실패');
            }
            start = start.add(Duration(days: 1));
          }
          context.read<OrderModel>().changeIsSaving(false);
          _refresh();
          Get.back();
        }
      );
      return;
    }

    context.read<OrderModel>().changeIsSaving(true);
    OrderResponse response = await _saveOrder(context.read<OrderTimeModel>().selectedOrderDate);
    if(response == null) {
      ToastUtils.showToast(msg: '주문 추가 실패');
    } else {
      ToastUtils.showToast(msg: '${response.boxNumber}번 추가 완료');
      _refresh();
      Get.back();
    }
    context.read<OrderModel>().changeIsSaving(false);
  }

  Future<OrderResponse> _saveOrder(DateTime orderDate) async {
    print(context.read<PromotionModel>()?.promotions?.map((node) => node.idx)?.toSet() ?? []);
    OrderResponse response = await context.read<OrderModel>().save(
        sIdx: context.read<SignInModel>().ownerInfo.idxStore,
        orderRequest: OrderRequest(
          orderDate: orderDate,
          idxOrderTime: context.read<OrderTimeModel>().selected.idx,
          idxDeliveryDetailSite: context.read<DeliveryDetailSiteModel>().selected.idx,
          paymentType: context.read<PaymentModel>().selectedPaymentType,
          usingPoint: 0,
          cashReceiptType: CashReceiptType.PERSONAL_PHONE_NUMBER,
          orderItems: this.items,
          note: this.note,
          idxesUsingPromotions: context.read<PromotionModel>()?.promotions?.map((node) => node.idx)?.toSet() ?? []
        )
    );
    return response;
  }

  void _refresh() async {
    // refresh
    OrderModel orderModel = context.read();
    OrderTimeModel orderTimeModel = context.read();
    DeliverySiteModel deliverySiteModel = context.read();
    DeliveryDetailSiteModel detailSiteModel = context.read();
    await orderModel.fetchAll(
        dIdx: deliverySiteModel.userDeliverySite?.idx,
        ddIdx: detailSiteModel.userDeliveryDetailSite?.idx,
        otIdx: orderTimeModel.userOrderTime?.idx,
        oDate: orderTimeModel.userOrderDate,
        isForceUpdate: true
    );
  }
}
