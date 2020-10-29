import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/providers/deliverysite/detail/delivery_detail_site_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:pomangam/providers/order/time/order_time_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_refresher.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_shimmer.dart';
import 'package:pomangam/views/mobile/widgets/order/view/content/order_view_content_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wakelock/wakelock.dart';

class OrderViewPage extends StatefulWidget {

  final GlobalKey scrollTarget;

  OrderViewPage({this.scrollTarget});

  @override
  _OrderViewPageState createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> with WidgetsBindingObserver {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  AppLifecycleState _notification = AppLifecycleState.detached;
  NeatPeriodicTaskScheduler _scheduler;

  @override
  void initState() {
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
    context.read<OrderViewModel>().changeIsCurrent(true);
    _initScheduler();
    _loading();

    super.initState();
  }

  void _initScheduler() {
    _scheduler = NeatPeriodicTaskScheduler(
      interval: Duration(seconds: 5),
      name: 'order-fetch',
      timeout: Duration(seconds: 10),
      minCycle: Duration(seconds: 1),
      task: () async {
        if(isAbleToFetch()) {
          await context.read<OrderModel>().fetchNew(
            dIdx: context.read<DeliverySiteModel>().userDeliverySite?.idx,
            ddIdx: context.read<DeliveryDetailSiteModel>().userDeliveryDetailSite?.idx,
            otIdx: context.read<OrderTimeModel>().userOrderTime?.idx,
            oDate: context.read<OrderTimeModel>().userOrderDate,
          );
        }
      },
    );
    _scheduler.start();
  }

  bool isAbleToFetch() {
    bool isCurrent = Get?.currentRoute != null && Get.currentRoute == '/BasePage';
    bool isValidAppLifecycleState = _notification == AppLifecycleState.detached || _notification == AppLifecycleState.resumed;
    //print('isCurrent : $isCurrent // isValidAppLifecycleState : $isValidAppLifecycleState // ${Get.currentRoute == '/BasePage'} // ${context.read<OrderViewModel>().isCurrent}');
    return isCurrent && isValidAppLifecycleState && Get.context.read<OrderViewModel>().isCurrent;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: OrderViewAppBar(),
      body: SafeArea(
        child: CustomRefresher(
          controller: _refreshController,
          onLoading: _loading,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            key: widget.scrollTarget,
            child: Consumer<OrderModel>(
              builder: (_, model, __) {
                if(model.isFetching) return _shimmer();
                if(model.orders.isEmpty) return _empty();
                if(context.read<OrderTimeModel>().userOrderTime == null) return _total(model.orders);
                return Column(
                  children: [
                    for(OrderResponse order in model.orders) Column(
                      children: [
                        OrderViewContentWidget(order: order),
                        CustomDivider()
                      ],
                    )
                  ]
                );
              },
            ),
          ),
        )
      ),
    );
  }

  String _textTime(String time) {
    String h = time.split(':')[0];
    String m = time.split(':')[1];
    return '$h시' + (m == '00' ? '' : ' $m분');
  }

  Widget _total(List<OrderResponse> orders) {
    Set<String> times = Set();
    orders.forEach((order) {
      times.add(order.arrivalTime);
    });
    return Column(
      children: [
        for(int i=0; i<times.length; i++) Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300],
                    width: 0.5
                  )
                ),
              ),
              padding: EdgeInsets.only(top: i == 0 ? 18 : 10, bottom: 18),
              child: Center(
                child: Text(_textTime(times.elementAt(i)), style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )),
              ),
            ),
            Column(
              children: [
                for(OrderResponse order in orders)
                  if(order.arrivalTime == times.elementAt(i))
                    Column(
                      children: [
                        OrderViewContentWidget(order: order),
                        CustomDivider()
                      ],
                    ),
              ],
            )
          ],
        )
      ]
    );
  }

  Widget _shimmer() {
    int r = Random().nextInt(5) + 1;
    return Column(
      children: List.generate(r, (index) => Column(
        children: [
          Container(
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(height: 25, width: 40),
                      SizedBox(height: 10),
                      CustomShimmer(height: 25, width: 140),
                      SizedBox(height: 5),
                      CustomShimmer(height: 18, width: 180),
                      SizedBox(height: 5),
                      CustomShimmer(height: 18, width: 90),
                    ],
                  ),
                ),
                CustomShimmer(width: 80, height: 80, borderRadius: BorderRadius.circular(50))
              ],
            ),
          ),
          CustomDivider()
        ],
      ))
    );
  }

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(child: Column(
        children: [
          Text('등록된 주문이 없습니다.', style: TextStyle(
            fontSize: 18,
            color: Colors.black
          )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward_sharp, size: 15, color: Colors.grey[500]),
              SizedBox(width: 5),
              Text('아래로 당겨서 새로고침.', style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500]
              )),
            ],
          ),
        ],
      )),
    );
  }

  Future<void> _refresh() async {
    _refreshController.loadComplete();
    context.read<OrderModel>().clear(notify: false);
    await _loading(isForceUpdate: true);
    _refreshController.refreshCompleted();
  }

  Future<void> _loading({bool isForceUpdate = false}) async {
    OrderModel orderModel = context.read();
    OrderTimeModel orderTimeModel = context.read();
    DeliverySiteModel deliverySiteModel = context.read();
    DeliveryDetailSiteModel detailSiteModel = context.read();

    if(orderModel.hasNext) {
      await orderModel.fetchAll(
        dIdx: deliverySiteModel.userDeliverySite?.idx,
        ddIdx: detailSiteModel.userDeliveryDetailSite?.idx,
        otIdx: orderTimeModel.userOrderTime?.idx,
        oDate: orderTimeModel.userOrderDate,
        isForceUpdate: isForceUpdate
      );
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
      _refreshController.loadNoData();
    }
  }
}
