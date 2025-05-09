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
              TextButtonApp(
                title: _option[i],
                textColor: screen.getIndex() == i ? Colors.white : Colors.white70,
                onPressed: (){ screen.setIndex(i);}
              ),
              const SizedBox(width: 30),
            ],
            if(!ac.getAccount()) TextButtonApp(
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
          ]
        );
      }
    );
  }
}
