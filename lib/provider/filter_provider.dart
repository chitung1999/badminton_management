import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  DateTime? _time;

  void setTime(String time) {
    if (time == 'Tất cả') {
      _time = null;
    } else {
      List<String> parts = time.split('/');
      _time = DateTime(int.parse(parts[1]), int.parse(parts[0]), 1);
    }
    notifyListeners();
  }

  DateTime? getTime() {return _time;}
}