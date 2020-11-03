import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';

class OrderSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        elevation: 1.0,
        title: '주문 관리',
        leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}