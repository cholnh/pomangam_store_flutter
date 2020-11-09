import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/domains/order/order_type.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/views/mobile/pages/order/detail/order_detail_page_type.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/order/detail/order_detail_bottom_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/detail/order_detail_info_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/detail/order_detail_menu_widget.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {

  final OrderDetailPageType pageType;

  OrderDetailPage({this.pageType});

  @override
  Widget build(BuildContext context) {
    OrderModel orderModel = context.watch();
    OrderResponse order = orderModel.detail;

    return ModalProgressHUD(
      inAsyncCall: orderModel.isOrderChanging(order.idx),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: _bottom(),
        appBar: BasicAppBar(
          title: '${order.boxNumber}번 주문상세',
          leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
          elevation: 1.0,
          actions: [
            Center(
              child: Text('${_type()}', style: TextStyle(
                fontSize: 13,
                color: _typeColor()
              )),
            ),
            SizedBox(width: 15)
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                OrderDetailMenuWidget(order: order, pageType: pageType),
                CustomDivider(),
                OrderDetailInfoWidget(order: order),
                CustomDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    bool fromView = pageType == OrderDetailPageType.FROM_VIEW;
    if(!fromView) return null;

    OrderModel orderModel = Get.context.read();
    OrderResponse order = orderModel.detail;

    switch(order.orderType) {
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        return OrderDetailBottomWidget(
          rightFlex: 3,
          leftText: '거절',
          rightText: '접수',
          onRightTap: () {
            Get.context.read<OrderModel>().approve(
                sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                oIdx: order.idx
            );
          },
          onLeftTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '거절 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) async {
                  await Get.context.read<OrderModel>().disapprove(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                  Get.back();
                },
                cancel: '취소'
            );
          },
        );
      case OrderType.DELIVERY_READY:
        return OrderDetailBottomWidget(
          leftFlex: 1,
          centerFlex: 1,
          rightFlex: 1,
          isActiveCenter: true,
          leftText: '취소',
          centerText: '지연',
          rightText: '픽업',
          centerColor: Color.fromRGBO(0xf9, 0xb8, 0x37, 1.0),
          rightColor: Color.fromRGBO(0x46, 0x52, 0xff, 1.0),
          onRightTap: () {
            Get.context.read<OrderModel>().deliveryPickup(
                sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                oIdx: order.idx
            );
          },
          onCenterTap: () {
            final TextEditingController _controller1 = TextEditingController();
            final TextEditingController _controller2 = TextEditingController();
            _controller1.text = '0';
            DialogUtils.dialogYesOrNo(Get.context, '지연 시간을 입력해주세요.',
                contents: _contents2(_controller1),
                height: 200,
                confirm: '전송',
                onConfirm: (_) {
                  DialogUtils.dialogYesOrNo(Get.context, '지연 사유를 입력해주세요.',
                      contents: _contents(_controller2),
                      height: 300,
                      confirm: '전송',
                      onConfirm: (_) {
                        Get.context.read<OrderModel>().deliveryDelay(
                            sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                            oIdx: order.idx,
                            min: int.tryParse(_controller1.text),
                            reason: _controller2.text
                        );
                      },
                      cancel: '취소'
                  );
                },
                cancel: '취소'
            );
          },
          onLeftTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '취소 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) async {
                  await Get.context.read<OrderModel>().disapprove(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                  Get.back();
                },
                cancel: '취소'
            );
          },
        );
      case OrderType.DELIVERY_DELAY:
        return OrderDetailBottomWidget(
          rightFlex: 3,
          leftText: '취소',
          rightText: '완료처리',
          rightColor: Color.fromRGBO(0x70, 0x70, 0x70, 1.0),
          onRightTap: () {
            Get.context.read<OrderModel>().deliverySuccess(
                sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                oIdx: order.idx
            );
          },
          onLeftTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '취소 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) async {
                  await Get.context.read<OrderModel>().disapprove(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                  Get.back();
                },
                cancel: '취소'
            );
          },
        );
      case OrderType.DELIVERY_PICKUP:
        return OrderDetailBottomWidget(
          leftFlex: 1,
          centerFlex: 1,
          rightFlex: 1,
          isActiveCenter: true,
          leftText: '취소',
          centerText: '지연',
          rightText: '완료처리',
          centerColor: Color.fromRGBO(0xf9, 0xb8, 0x37, 1.0),
          rightColor: Color.fromRGBO(0x70, 0x70, 0x70, 1.0),
          onRightTap: () {
            Get.context.read<OrderModel>().deliverySuccess(
                sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                oIdx: order.idx
            );
          },
          onCenterTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '지연 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) {
                  Get.context.read<OrderModel>().deliveryDelay(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                },
                cancel: '취소'
            );
          },
          onLeftTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '취소 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) async {
                  await Get.context.read<OrderModel>().disapprove(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                  Get.back();
                },
                cancel: '취소'
            );
          },
        );
      case OrderType.DELIVERY_SUCCESS:
        return OrderDetailBottomWidget(
          isActiveLeft: false,
          rightFlex: 1,
          rightText: '취소',
          rightColor: Colors.white,
          rightFontColor: Colors.black,
          onRightTap: () {
            final TextEditingController _controller = TextEditingController();
            DialogUtils.dialogYesOrNo(Get.context, '취소 사유를 입력해주세요.',
                contents: _contents(_controller),
                height: 250,
                confirm: '전송',
                onConfirm: (_) async {
                  await Get.context.read<OrderModel>().disapprove(
                      sIdx: Get.context.read<SignInModel>().ownerInfo.idxStore,
                      oIdx: order.idx,
                      reason: _controller.text
                  );
                  Get.back();
                },
                cancel: '취소'
            );
          },
        );
      default:
    }
    return null;
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

  Widget _contents2(TextEditingController _controller) {
    return Container(
      color: Colors.grey[100],
      height: 40,
      width: 60,
      child: TextFormField(
          scrollPhysics: BouncingScrollPhysics(),
          controller: _controller,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.number,
          maxLines: null,
          style: TextStyle(fontSize: 15, color: Colors.black),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            suffixText: '분'
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(3),
          ],
      ),
    );
  }

  String _type() {
    String nameType = '';
    OrderModel orderModel = Get.context.read();
    OrderResponse order = orderModel.detail;
    switch(order.orderType) {
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
        nameType = '결제실패'; break;
      case OrderType.PAYMENT_READY:
        nameType = '결제대기'; break;
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        nameType = '주문대기'; break;
      case OrderType.DELIVERY_READY:
        nameType = '메뉴준비'; break;
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        nameType = '배달중'; break;
      case OrderType.DELIVERY_SUCCESS:
        nameType = '배달완료'; break;
      case OrderType.PAYMENT_CANCEL:
      case OrderType.PAYMENT_REFUND:
      case OrderType.ORDER_REFUSE:
      case OrderType.ORDER_CANCEL:
        nameType = '주문취소'; break;
      case OrderType.MISS_BY_DELIVERER:
      case OrderType.MISS_BY_STORE:
        nameType = '주문누락'; break;
      default:
        nameType = '알수없음'; break;
    }
    return nameType;
  }

  Color _typeColor() {
    Color color = Theme.of(Get.context).textTheme.headline1.color;
    OrderModel orderModel = Get.context.read();
    OrderResponse order = orderModel.detail;
    switch(order.orderType) {
      case OrderType.PAYMENT_READY_FAIL_POINT:
      case OrderType.PAYMENT_READY_FAIL_COUPON:
      case OrderType.PAYMENT_READY_FAIL_PROMOTION:
      case OrderType.PAYMENT_FAIL:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.PAYMENT_READY:
      case OrderType.PAYMENT_SUCCESS:
      case OrderType.ORDER_READY:
      case OrderType.ORDER_QUICK_READY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_READY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_PICKUP:
      case OrderType.DELIVERY_DELAY:
        color = Theme.of(Get.context).primaryColor; break;
      case OrderType.DELIVERY_SUCCESS:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.PAYMENT_CANCEL:
      case OrderType.PAYMENT_REFUND:
      case OrderType.ORDER_REFUSE:
      case OrderType.ORDER_CANCEL:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      case OrderType.MISS_BY_DELIVERER:
      case OrderType.MISS_BY_STORE:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
      default:
        color = Theme.of(Get.context).textTheme.headline1.color; break;
    }
    return color;
  }
}
