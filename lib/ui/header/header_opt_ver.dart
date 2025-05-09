import 'package:badminton_management/provider/account_provider.dart';
import 'package:badminton_management/ui/header/menu_anchor_item.dart';
import 'package:badminton_management/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:badminton_management/provider/screen_provider.dart';
import 'package:provider/provider.dart';

class HeaderOptVer extends StatefulWidget {
  const HeaderOptVer({super.key});

  @override
  State<HeaderOptVer> createState() => _HeaderOptVerState();
}

class _HeaderOptVerState extends State<HeaderOptVer> {
  final List<String> _option = ['Trang chủ', 'Tiền thu', 'Tiền chi'];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ScreenProvider, AccountProvider>(
      builder: (context, screen, ac, child) {
        return MenuAnchor( builder: (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.menu, size: 40, color: Colors.white70),
          );
        },
          menuChildren: [
            for(int i = 0; i < _option.length; i++)...[
              MenuAnchorItem(text: _option[i], onPressed: () {screen.setIndex(i);})
            ],
            if(!ac.getAccount()) MenuAnchorItem(
              text: 'Đăng nhập',
              onPressed: () {
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