import 'package:flutter/material.dart';

class TextBtn extends StatefulWidget {
  const TextBtn(
      {super.key,
        required this.title,
        this.size = 18,
        this.color = Colors.white70,
        required this.onPressed});

  final String title;
  final double size;
  final Color color;
  final Function() onPressed;

  @override
  _TextBtnState createState() => _TextBtnState();
}

class _TextBtnState extends State<TextBtn> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(widget.title, style: TextStyle(fontSize: widget.size, fontWeight: FontWeight.bold, color: widget.color)),
      onPressed: (){widget.onPressed();},
    );
  }
}