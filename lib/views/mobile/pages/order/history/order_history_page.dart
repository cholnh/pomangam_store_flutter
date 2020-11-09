import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/domains/order/order_response.dart';
import 'package:pomangam/providers/order/order_history_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/views/mobile/pages/order/detail/order_detail_page.dart';
import 'package:pomangam/views/mobile/pages/order/detail/order_detail_page_type.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_refresher.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_shimmer.dart';
import 'package:pomangam/views/mobile/widgets/order/history/order_history_content_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  GlobalKey scrollTarget;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  void initState() {
    //_loading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomRefresher(
          controller: _refreshController,
          onLoading: _loading,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            key: scrollTarget,
            child: Consumer<OrderHistoryModel>(
              builder: (_, model, __) {
                if(model.isFetching) return _shimmer();
                if(model.orders.isEmpty) return _empty();
                return Column(
                    children: [
                      for(OrderResponse order in model.orders) Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<OrderModel>().detail = order;
                              Get.to(OrderDetailPage(pageType: OrderDetailPageType.FROM_HISTORY));
                            },
                            child: OrderHistoryContentWidget(order: order)
                          ),
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

  Widget _shimmer() {
    return Column(
        children: List.generate(10, (index) => Column(
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
    context.read<OrderHistoryModel>().clear(notify: false);
    await _loading(isForceUpdate: true);
    _refreshController.refreshCompleted();
  }

  Future<void> _loading({bool isForceUpdate = false}) async {
    OrderHistoryModel orderHistoryModel = context.read();

    if(orderHistoryModel.hasNext) {
      await orderHistoryModel.fetchAll(
        dIdx: null,
        ddIdx: null,
        otIdx: null,
        oDate: null,
        isForceUpdate: isForceUpdate
      );
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
      _refreshController.loadNoData();
    }
  }
}
