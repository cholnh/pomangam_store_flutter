import 'package:flutter/cupertino.dart';

class OrderViewModel with ChangeNotifier {

  bool isCurrent = false;

  void changeIsCurrent(bool tf, {bool notify = false}) {
    this.isCurrent = tf;
    if(notify) {
      notifyListeners();
    }
  }
}