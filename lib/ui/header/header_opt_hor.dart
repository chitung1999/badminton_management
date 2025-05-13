import 'package:badminton_management/provider/account_provider.dart';
import 'package:badminton_management/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:badminton_management/common/text_button.dart';
import 'package:badminton_management/provider/screen_provider.dart';
import 'package:provider/provider.dart';
import 'logo_app.dart';

class HeaderOptHor extends StatefulWidget {
  const HeaderOptHor({super.key});

  @override
  State<HeaderOptHor> createState() => _HeaderOptHorState();
}

class _HeaderOptHorState extends State<HeaderOptHor> {
  final List<String> _option = ['Trang chủ', 'Tiền thu', 'Tiền chi'];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ScreenProvider, AccountProvider>(
      builder: (context, screen, ac, child) {
        return Row(
          children: [
            const LogoApp(),
            const SizedBox(width: 70),
            for (int i = 0; i < _option.length; i++)...[
              Column(
                children: [
                  Container(
                    width: 130,
                    height: 60,
                    decoration: BoxDecoration( border: Border(bottom: BorderSide(width: 5, color: screen.getIndex() == i ? Colors.white : Colors.transparent))),
                    child: TextButtonApp(
                      title: _option[i],
                      textColor: screen.getIndex() == i ? Colors.white : Colors.white70,
                      onPressed: (){ screen.setIndex(i);}
                    ),
                  ),
                ],
              ),
            ],
            if(!ac.getAccount()) Container(
              width: 130,
              height: 60,
              decoration: const BoxDecoration( border: Border(bottom: BorderSide(width: 5, color: Colors.transparent))),
              child: TextButtonApp(
                title: 'Đăng nhập',
                textColor: Colors.white70,
                onPressed: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {return const Login();}
                  );
                }
              ),
            ),
          ]
        );
      }
    );
  }
}
