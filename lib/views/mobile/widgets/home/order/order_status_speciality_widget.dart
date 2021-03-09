import 'package:flutter/material.dart';
import 'package:pomangam/_bases/constants/endpoint.dart';
import 'package:pomangam/providers/order/order_view_model.dart';
import 'package:provider/provider.dart';

class OrderStatusSpecialityWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    bool isPcWebFullScreen = context.watch<OrderViewModel>().isFullScreen && kIsPcWeb(context: context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey[200],
              width: 1.0
          )
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('배달 특이사항', style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1.0, thickness: 1.0),
                  _speciality(14, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(13, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(12, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(11, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(10, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(9, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(8, '반찬 많이 주지 마세요. 반찬 많이 주지 마세요. 반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(7, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(6, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(5, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(4, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(3, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(2, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _speciality(1, '반찬 많이 주지 마세요. 반찬 많이 주지 마세요. 반찬 많이 주지 마세요.', '2021-01-22')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _speciality(int index, String title, String date) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('$index. $title', style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              SizedBox(width: 10),
              Text('$date', style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400]
              ))
            ],
          ),
        ),
        Divider(height: 1.0, thickness: 1.0)
      ],
    );
  }
}
