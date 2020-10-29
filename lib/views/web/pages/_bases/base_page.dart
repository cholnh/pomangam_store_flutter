import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pomangam/views/web/pages/home/home_page.dart';
import 'package:pomangam/views/web/pages/order/order_page.dart';
import 'package:pomangam/views/web/pages/order_history/order_history_page.dart';

class BasePage extends StatefulWidget {

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final PersistentTabController _tabController = PersistentTabController(initialIndex: 0);

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: PersistentTabView(
        controller: _tabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
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
        onItemSelected: (index) async {},
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      OrderPage(),
      OrderHistoryPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems({bool hasOrder = false}) {

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
          child: Icon(CupertinoIcons.play_arrow)
        ),
        title: '주문 접수 중',
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
