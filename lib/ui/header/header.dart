import 'package:badminton_management/ui/header/header_opt_hor.dart';
import 'package:badminton_management/ui/header/header_opt_ver.dart';
import 'package:flutter/material.dart';
import 'drop_down.dart';
import 'logo_app.dart';

class HeaderApp extends StatelessWidget {
  const HeaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff365c7d), Color(0xff6687a4), Color(0xff365c7d)],
          stops: [0, 0.5, 1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (width > 1100)
            const HeaderOptHor()
          else
            Row(
              children: [
                const HeaderOptVer(),
                if (width > 600)...[
                  const SizedBox(width: 40),
                  const LogoApp(),
                ]
              ]
            ),
          const DropDown(),
        ],
      ),
    );
  }
}
