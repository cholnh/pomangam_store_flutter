import 'package:flutter/cupertino.dart';
import 'package:pomangam/domains/payment/cash_receipt/cash_receipt.dart';
import 'package:pomangam/domains/payment/payment_type.dart';

class PaymentModel with ChangeNotifier {

  PaymentType viewSelectedPaymentType = PaymentType.COMMON_V_BANK;
  PaymentType selectedPaymentType = PaymentType.COMMON_V_BANK;

  CashReceipt viewSelectedCashReceipt;
  CashReceipt selectedCashReceipt;

  void changeViewSelectedPaymentType(PaymentType paymentType) {
    this.viewSelectedPaymentType = paymentType;
    notifyListeners();
  }

  void changeSelectedPaymentType(PaymentType paymentType) {
    this.selectedPaymentType = paymentType;
    notifyListeners();
  }

  void changeViewSelectedCashReceipt(CashReceipt cashReceipt) {
    this.viewSelectedCashReceipt = cashReceipt;
    notifyListeners();
  }

  void changeSelectedCashReceipt(CashReceipt cashReceipt) {
    this.selectedCashReceipt = cashReceipt;
    notifyListeners();
  }
}