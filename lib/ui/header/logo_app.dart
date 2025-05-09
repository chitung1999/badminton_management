import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  const LogoApp(
      {super.key,
        this.size = 25
      });

  final double size;

  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          'data/icon/icon_badminton.png',
          width: widget.size * 1.5,
          height: widget.size * 1.5,
        ),
        Text(
          ' Badminton ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.size,
            color: Colors.white
          )
        ),
        Text(
            'manager',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: widget.size * 0.8,
                color: Colors.white
            )
        )
      ],
    );
  }
}
