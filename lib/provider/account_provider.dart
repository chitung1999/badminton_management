import 'package:flutter/material.dart';

class AccountProvider with ChangeNotifier {
  bool _isAdmin = false;

  void setAccount(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  bool getAccount() {return _isAdmin;}
}
