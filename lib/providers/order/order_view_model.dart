import 'package:flutter/cupertino.dart';

class OrderViewModel with ChangeNotifier {

  bool isCurrent = false;
  bool isFullScreen = false;

  void changeIsCurrent(bool tf, {bool notify = false}) {
    this.isCurrent = tf;
    if(notify) {
      notifyListeners();
    }
  }

  void changeIsFullScreen(bool tf, {bool notify = false}) {
    this.isFullScreen = tf;
    if(notify) {
      notifyListeners();
    }
  }
}