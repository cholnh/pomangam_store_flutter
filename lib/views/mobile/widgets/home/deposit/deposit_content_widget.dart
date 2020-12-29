import 'package:flutter/material.dart';
import 'package:pomangam/_bases/util/string_utils.dart';
import 'package:pomangam/domains/vbank/vbank.dart';
import 'package:pomangam/domains/vbank/vbank_status.dart';

class DepositContentWidget extends StatelessWidget {

  final VBank deposit;

  DepositContentWidget({this.deposit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${deposit.name} (${deposit.bank})', style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold
              )),
              Text('${StringUtils.comma(deposit.input)}원', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              )),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_status()} (#${deposit.idx})', style: TextStyle(
                color: Colors.black,
                fontSize: 13
              )),
              Text('${deposit.transferDate}', style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              )),
            ],
          )
        ],
      ),
    );
  }

  String _status() {
    switch(deposit.status) {
      case VBankStatus.READY: return '확인 중';
      case VBankStatus.SUCCESS: return '입금 (일반배달)';
      case VBankStatus.FAIL_SAME_NAME: return '확인실패 (동명이인)';
      case VBankStatus.FAIL_UNKNOWN_NAME: return '입금';
    }
    return '오류';
  }
}
