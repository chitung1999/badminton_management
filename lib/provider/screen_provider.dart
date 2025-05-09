import 'package:flutter/material.dart';

class ScreenProvider with ChangeNotifier {
  int _index = 0;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  int getIndex() {return _index;}
}
