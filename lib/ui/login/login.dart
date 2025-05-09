import 'package:badminton_management/common/notify.dart';
import 'package:badminton_management/common/text_button.dart';
import 'package:badminton_management/provider/account_provider.dart';
import 'package:badminton_management/server/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isHidePassword = true;

  bool onLogin() {
    if(_username.text.isEmpty || _password.text.isEmpty) {
      Notify.show(context, NotiType.notice, 'Tài khoản hoặc mật khẩu trống!');
      return false;
    }

    if(_username.text != account.username() || _password.text != account.password()) {
      Notify.show(context, NotiType.notice, 'Tài khoản hoặc mật khẩu không đúng!');
      return false;
    }

    Notify.show(context, NotiType.success, 'Đăng nhập thành công!');
    return true;
  }

  @override
  void initState() {
    _username.text = 'admin';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black12, width: 2)
      ),

      child: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'LOGIN',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xff365c7d))
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _username,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'User name',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.withOpacity(0.3)
                  ),
                  icon: const Icon(Icons.person)
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _password,
                obscureText: _isHidePassword,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.withOpacity(0.3)
                  ),
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {_isHidePassword = !_isHidePassword;});
                    }
                  )
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButtonApp(
                    title: 'Cancel',
                    width: 130,
                    height: 50,
                    textSize: 17,
                    radius: 5,
                    bgColor: Colors.black12,
                    outlineColor: Colors.black26,
                    onPressed: () {
                      Navigator.pop(context, false);
                    }
                  ),
                  Consumer<AccountProvider>(
                    builder: (context, ac, chill) {
                      return TextButtonApp(
                        title: 'OK',
                        width: 130,
                        height: 50,
                        textSize: 17,
                        radius: 5,
                        bgColor: Colors.white,
                        outlineColor: Colors.blueAccent,
                        onPressed: () {
                          if (onLogin()) {
                            ac.setAccount(true);
                            Navigator.pop(context, false);
                          }
                        }
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ))
    );
  }
}
