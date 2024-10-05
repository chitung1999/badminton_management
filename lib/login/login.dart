import '../database/database.dart';
import 'package:flutter/material.dart';
import '../common/text_box_btn.dart';
import '../common/image_btn.dart';
import '../common/config_app.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isHidePassword = true;

  @override
  void initState() {
    _username.text = 'admin';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueGrey)
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
              children: [
                Expanded(
                  child: TextBoxBtn(
                    title: 'Cancel',
                    width: 180,
                    height: 40,
                    textSize: 15,
                    radius: 5,
                    bgColor: Colors.white,
                    textColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context, false);
                    }
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextBoxBtn(
                      title: 'OK',
                      width: 180,
                      height: 40,
                      textSize: 15,
                      radius: 5,
                      onPressed: () {
                        if (_username.text.isEmpty || _password.text.isEmpty) {
                          ConfigApp.showNotify(context, MessageType.error, StatusApp.blankAccount);
                        } else if(_username.text == database.account.user && _password.text == database.account.pw) {
                          Navigator.pop(context, true);
                        } else {
                          ConfigApp.showNotify(context, MessageType.error, StatusApp.incorrectAccount);
                        }
                      }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('or login with',
                style:
                    TextStyle(fontSize: 15, color: Colors.black54)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageBtn(
                  url: 'data/icon/porn.png',
                  size: 60,
                  onPressed: () {
                    ConfigApp.showNotify(context, MessageType.notice, StatusApp.newFeaturePornhub);
                  }),
                const SizedBox(height: 30),
                ImageBtn(
                  url: 'data/icon/facebook.png',
                  size: 60,
                  onPressed: () {
                    ConfigApp.showNotify(context, MessageType.notice, StatusApp.newFeature);
                  }),
              ],
            ),
          ],
        ))
    );
  }
}
