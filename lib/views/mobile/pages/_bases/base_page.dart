import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pomangam/_bases/util/toast_utils.dart';
import 'package:pomangam/providers/order/order_history_model.dart';
import 'package:pomangam/providers/order/order_model.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:pomangam/views/mobile/pages/home/home_page.dart';
import 'package:pomangam/views/mobile/pages/order/history/order_history_page.dart';
import 'package:pomangam/views/mobile/pages/order/view/order_view_page.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 1);
  final GlobalKey scrollTarget = GlobalKey();
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    bool onoff = context.watch<StoreModel>().onOff == OrderOnOff.ON;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: PersistentTabView(
        controller: _tabController,
        screens: _buildScreens(),
        items: _navBarsItems(onoff: onoff),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).backgroundColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          colorBehindNavBar: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5
            )
          ),
        ),
        popAllScreensOnTapOfSelectedTab: true,

        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200)
        ),

        navBarStyle: NavBarStyle.style3,
        padding: NavBarPadding.symmetric(horizontal: 5),
        navBarHeight: 57,
        onItemSelected: (index) async {
          switch(index) {
            case 0:
              context.read<OrderViewModel>().changeIsCurrent(false);
              break;
            case 1:
              OrderViewModel orderViewModel = context.read();
              if(orderViewModel.isCurrent) {
                Scrollable.ensureVisible(scrollTarget.currentContext, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
              }
              orderViewModel.changeIsCurrent(true);
              break;
            case 2:
              context.read<OrderViewModel>().changeIsCurrent(false);
              OrderHistoryModel orderHistoryModel = context.read();
              orderHistoryModel.clear(notify: false);
              await orderHistoryModel.fetchAll(
                  dIdx: null,
                  ddIdx: null,
                  otIdx: null,
                  oDate: null,
                  isForceUpdate: true
              );
              break;
          }

        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ToastUtils.showToast(msg: '종료하려면 한번 더 누르세요.');
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      OrderViewPage(scrollTarget: scrollTarget),
      OrderHistoryPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems({bool hasOrder = false, bool onoff}) {

    final Color activeColor = Theme.of(Get.context).primaryColor;
    final Color inactiveColor = Theme.of(Get.context).iconTheme.color;

    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: '홈',
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Badge(
          showBadge: hasOrder,
          badgeContent: Container(),
          padding: const EdgeInsets.all(2),
          elevation: 0.0,
          position: BadgePosition.topEnd(top: 0, end: -5),
          child: Consumer<StoreModel>(
            builder: (_, storeModel, __) {
              return Consumer<OrderModel>(
                builder: (_, orderModel, __) {
                  if(storeModel.onOff == OrderOnOff.OFF) return Icon(CupertinoIcons.pause_solid);
                  if(orderModel.isFetching || orderModel.isNewFetching) return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: CupertinoActivityIndicator(),
                  );
                  else return Icon(CupertinoIcons.play_arrow_solid);
                },
              );
            },
          )
        ),
        title: onoff ? '주문 접수 중' : '주문 일시정지',
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.news),
        title: '주문내역',
        activeColor: activeColor,
        inactiveColor: inactiveColor,
      ),
    ];
  }
}
