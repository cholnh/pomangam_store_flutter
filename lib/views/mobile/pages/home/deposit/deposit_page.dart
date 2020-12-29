import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomangam/domains/vbank/vbank.dart';
import 'package:pomangam/providers/vbank/vbank_model.dart';
import 'package:pomangam/views/mobile/widgets/_bases/basic_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/_bases/custom_divider.dart';
import 'package:pomangam/views/mobile/widgets/home/deposit/deposit_content_widget.dart';
import 'package:pomangam/views/web/widgets/_bases/custom_refresher.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        elevation: 1.0,
        title: '입금 관리',
        leadingIcon: const Icon(CupertinoIcons.back, size: 20, color: Colors.black),
      ),
      body: SafeArea(
        child: CustomRefresher(
          controller: _refreshController,
          onLoading: _loading,
          onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Consumer<VBankModel>(
                builder: (_, model, __) {
                  if(model.isFetching) return CupertinoActivityIndicator();
                  if(model.deposits.isEmpty) return _empty();
                  return Column(
                      children: [
                        for(VBank deposit in model.deposits) Column(
                          children: [
                            DepositContentWidget(deposit: deposit),
                            Divider(height: 1.0, thickness: 0.5)
                          ],
                        )
                      ]
                  );
                },
              ),
            )
        )
      ),
    );
  }

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(child: Column(
        children: [
          Text('입금내역이 없습니다.', style: TextStyle(
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
    context.read<VBankModel>().clear(notify: false);
    await _loading(isForceUpdate: true);
    _refreshController.refreshCompleted();
  }

  Future<void> _loading({bool isForceUpdate = false}) async {
    VBankModel vBankModel = context.read();

    if(vBankModel.hasNext) {
      await vBankModel.fetchAll(isForceUpdate: isForceUpdate);
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
      _refreshController.loadNoData();
    }
  }
}
