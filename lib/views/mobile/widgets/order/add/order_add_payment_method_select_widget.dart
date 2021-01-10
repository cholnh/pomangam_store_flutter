import 'package:flutter/material.dart';
import 'package:pomangam/domains/payment/payment_type.dart';
import 'package:pomangam/providers/payment/payment_model.dart';
import 'package:provider/provider.dart';

class OrderAddPaymentMethodSelectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaymentModel paymentModel = context.watch();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.grey[100],
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _item(paymentModel, PaymentType.COMMON_V_BANK),
              _item(paymentModel, PaymentType.CONTACT_CREDIT_CARD),
              _item(paymentModel, PaymentType.CONTACT_CASH),
              _item(paymentModel, PaymentType.COMMON_BANK),
              _item(paymentModel, PaymentType.COMMON_CREDIT_CARD),
              _item(paymentModel, PaymentType.COMMON_PHONE),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(PaymentModel paymentModel, PaymentType paymentType) {

    return GestureDetector(
      onTap: () {
        paymentModel.changeViewSelectedPaymentType(paymentType);
      },
      child: RadioListTile(
        title: Text('${convertPaymentTypeToText(paymentType)}', style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        )),
        value: paymentModel.viewSelectedPaymentType == paymentType,
        groupValue: true,
      ),
    );
  }

}
