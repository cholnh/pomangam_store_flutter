import 'package:flutter/material.dart';

class OrderStatusNoticeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: Text('공지사항', style: TextStyle(
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
                  _notice(14, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(13, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(12, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(11, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(10, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(9, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(8, '반찬 많이 주지 마세요. 반찬 많이 주지 마세요. 반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(7, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(6, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(5, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(4, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(3, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(2, '반찬 많이 주지 마세요.', '2021-01-22'),
                  _notice(1, '반찬 많이 주지 마세요. 반찬 많이 주지 마세요. 반찬 많이 주지 마세요.', '2021-01-22')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notice(int index, String title, String date) {
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
