import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/providers/order/order_status_model.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/home/order/order_status_board_widget.dart';
import 'package:pomangam/views/mobile/widgets/home/order/order_status_chart_widget.dart';
import 'package:pomangam/views/mobile/widgets/home/order/order_status_notice_widget.dart';
import 'package:pomangam/views/mobile/widgets/home/order/order_status_speciality_widget.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:intl/intl.dart';

class OrderStatusBoardPage extends StatefulWidget {
  @override
  _OrderStatusBoardPageState createState() => _OrderStatusBoardPageState();
}

class _OrderStatusBoardPageState extends State<OrderStatusBoardPage> {

  NeatPeriodicTaskScheduler _scheduler;

  @override
  void initState() {
    Wakelock.enable();
    _initScheduler();

    super.initState();
  }

  void _initScheduler() {
    _scheduler = NeatPeriodicTaskScheduler(
      interval: Duration(seconds: 5),
      name: 'order-fetch',
      timeout: Duration(seconds: 10),
      minCycle: Duration(seconds: 1),
      task: () async {
        _update();
      },
    );
    _scheduler.start();
  }

  void _update() {
    OrderStatusModel orderStatusModel = context.read();
    orderStatusModel.changeLastUpdated(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    bool isPcWebFullScreen = context.watch<OrderViewModel>().isFullScreen && kIsPcWeb(context: context);
    OrderStatusModel orderStatusModel = context.watch();

    return WillPopScope(
      onWillPop: () async {
        if(context.read<OrderViewModel>().isFullScreen) {
          context.read<OrderViewModel>().changeIsFullScreen(false, notify: true);
        }
        return true;
      },
      child: Scaffold(
        appBar: BasicAppBar(
          elevation: 1.0,
          title: '11:34',
          leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
          onLeadingTap: () {
            context.read<OrderViewModel>().changeIsFullScreen(false, notify: true);
            Get.back();
          },
          actions: [
            if(isPcWebFullScreen) Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                children: [
                  Text(orderStatusModel.lastUpdated != null
                      ? '마지막 업데이트 ${DateFormat('yyyy-MM-dd HH:mm:ss').format(orderStatusModel.lastUpdated)}'
                      : '업데이트 미실행', style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  )),
                  SizedBox(width: 5),
                  Icon(Icons.refresh, size: 20, color: Colors.black),
                ],
              ),
            )
            else Icon(Icons.refresh, size: 20, color: Colors.black),
            SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  context.read<OrderViewModel>().changeIsFullScreen(!context.read<OrderViewModel>().isFullScreen, notify: true);
                },
                child: Material(
                  color: Colors.transparent,
                  child: Icon(context.watch<OrderViewModel>().isFullScreen
                      ? CupertinoIcons.fullscreen_exit
                      : CupertinoIcons.fullscreen,
                    size: 20, color: Colors.black)
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: isPcWebFullScreen ? _gridScreen() : _listScreen(),
        ),
      ),
    );
  }

  Widget _listScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          _first(),
          SizedBox(
            height: 300,
            child: _second()
          ),
          SizedBox(
            height: 300,
            child: _third()
          ),
          _fourth()
        ],
      ),
    );
  }

  Widget _gridScreen() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _first()
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _second(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _third(),
                    )
                  ],
                )
              ),
              Expanded(
                flex: 1,
                child: _fourth()
              )
            ],
          ),
        )
      ],
    );
  }

  // 주문 현황판
  Widget _first() {
    return OrderStatusBoardWidget();
  }

  // 공지사항 & 배달특이사항
  Widget _second() {
    return OrderStatusNoticeWidget();
  }

  // 차트
  Widget _third() {
    return OrderStatusSpecialityWidget();
  }

  Widget _fourth() {
    return OrderStatusChartWidget();
  }
}
