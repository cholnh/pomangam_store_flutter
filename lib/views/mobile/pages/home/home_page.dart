import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/providers/sign/sign_in_model.dart';
import 'package:pomangam/providers/store/store_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_dialog_utils.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/home/category/home_category_widget.dart';
import 'package:pomangam/views/mobile/widgets/home/home_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/home/store_info/home_store_info_widget.dart';
import 'package:pomangam/views/mobile/widgets/order/view/order_view_type.dart';
import 'package:pomangam/views/splash_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: HomeAppBar(
        backgroundColor: context.watch<StoreModel>().onOff == OrderOnOff.ON
          ? Theme.of(context).primaryColor
          : Colors.grey[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              HomeStoreInfoWidget(),
              CustomDivider(),
              HomeCategoryWidget(),
              CustomDivider(),
              _logout(),
              CustomDivider(),
            ],
          )
        )
      )
    );
  }

  Widget _logout() {
    return GestureDetector(
      onTap: _signOut,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.black),
              SizedBox(width: 15),
              Text('로그아웃', style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _signOut() {
    SignInModel signInModel = Get.context.read();
    DialogUtils.dialogYesOrNo(Get.context, '로그아웃 하시겠습니까?', onConfirm: (dialogContext) async {
      if(!signInModel.isSigningOut) {
        await signInModel.signOut();
        Get.offAll(SplashPage(), transition: Transition.fade);
        if( Navigator.of(dialogContext).canPop()) {
          Navigator.of(dialogContext).pop();
        }
      }
    });
  }
}
