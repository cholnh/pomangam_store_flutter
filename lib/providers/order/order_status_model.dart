import 'package:flutter/cupertino.dart';

class OrderStatusModel with ChangeNotifier {

  DateTime lastUpdated;

  void changeLastUpdated(DateTime lastUpdated, {bool notify = true}) {
    this.lastUpdated = lastUpdated;
    if(notify) {
      notifyListeners();
    }
  }
}