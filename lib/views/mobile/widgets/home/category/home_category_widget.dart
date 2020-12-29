import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomangam/views/mobile/pages/home/deposit/deposit_page.dart';

class HomeCategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _menu(title: '입금 관리', icon: Icon(Icons.article_outlined, size: 20, color: Colors.black), onTap: () => Get.to(DepositPage())),
          _divider(),
          _menu(title: '매장 관리', icon: Icon(Icons.storefront_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '메뉴 관리', icon: Icon(Icons.fastfood_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '시간 관리', icon: Icon(Icons.access_time_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '주문 관리', icon: Icon(Icons.assignment_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '스토리 관리', icon: Icon(Icons.camera_alt_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '리뷰 관리', icon: Icon(Icons.rate_review_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '직원 관리', icon: Icon(Icons.supervisor_account_outlined, size: 20, color: Colors.black)),
          _divider(),
          _menu(title: '매출 관리', icon: Icon(Icons.money_outlined, size: 20, color: Colors.black))
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(thickness: 0.5, height: kIsWeb ? 1.0 : 0.5);
  }

  Widget _menu({String title, Icon icon, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              icon,
              SizedBox(width: 15),
              Text('$title', style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ))
            ],
          ),
        ),
      ),
    );
  }
}
