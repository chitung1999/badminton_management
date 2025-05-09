class Account {
  String _username = '';
  String _password = '';

  Account._internal();

  factory Account() {
    return _instance;
  }

  static final Account _instance = Account._internal();

  void setAccount(String username, String pw) {
    if (_username.isNotEmpty && _password.isNotEmpty) return;

    _username = username;
    _password = pw;
  }

  String username() => _username;
  String password() => _password;
}

final account = Account();