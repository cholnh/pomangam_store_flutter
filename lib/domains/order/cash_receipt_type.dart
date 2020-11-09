enum CashReceiptType {

  /// 개인소득공제 (휴대폰번호)
  PERSONAL_PHONE_NUMBER,

  /// 개인소득공제 (현금영수증카드)
  PERSONAL_CARD_NUMBER,

  /// 사업자증빙 (사업자등록번호)
  BUSINESS_REGISTRATION_NUMBER,

  /// 사업자증빙 (현금영수증카드)
  BUSINESS_CARD_NUMBER

}

String convertCashReceiptTypeToText(CashReceiptType type) {
  if(type != null) {
    switch(type) {
      case CashReceiptType.PERSONAL_PHONE_NUMBER:
        return '개인소득공제 (휴대폰번호)';
      case CashReceiptType.PERSONAL_CARD_NUMBER:
        return '개인소득공제 (현금영수증카드)';
      case CashReceiptType.BUSINESS_REGISTRATION_NUMBER:
        return '사업자증빙 (사업자등록번호)';
      case CashReceiptType.BUSINESS_CARD_NUMBER:
        return '사업자증빙 (현금영수증카드)';
    }
  }
  return '';
}

String convertCashReceiptTypeToShortText(CashReceiptType type) {
  if(type != null) {
    switch(type) {
      case CashReceiptType.PERSONAL_PHONE_NUMBER:
        return '개인소득공제';
      case CashReceiptType.PERSONAL_CARD_NUMBER:
        return '개인소득공제';
      case CashReceiptType.BUSINESS_REGISTRATION_NUMBER:
        return '사업자증빙';
      case CashReceiptType.BUSINESS_CARD_NUMBER:
        return '사업자증빙';
    }
  }
  return '';
}