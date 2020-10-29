import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pomangam/providers/deliverysite/delivery_site_model.dart';
import 'package:pomangam/views/mobile/pages/deliverysite/delivery_site_page_type.dart';
import 'package:pomangam/views/mobile/widgets/deliverysite/delivery_site_app_bar.dart';
import 'package:pomangam/views/mobile/widgets/deliverysite/delivery_site_search_history_widget.dart';
import 'package:provider/provider.dart';

class DeliverySitePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    DeliverySitePageType deliverySitePageType = Get.arguments;
    bool isFirst = deliverySitePageType == DeliverySitePageType.FROM_INIT;
    return Consumer<DeliverySiteModel>(
      builder: (_, model, __) {
        return ModalProgressHUD(
          inAsyncCall: model.isChanging,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: DeliverySiteAppBar(isFirst: isFirst),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: DeliverySiteSearchHistoryWidget(isFirst: isFirst),
              ),
            ),
          ),
        );
      }
    );
  }
}
