import 'package:flutter/material.dart';

class TextButtonApp extends StatefulWidget {
  const TextButtonApp(
    {
      super.key,
      required this.title,
      this.width = 0,
      this.height = 0,
      this.radius = 0,
      this.bgColor = Colors.transparent,
      this.outlineColor = Colors.transparent,
      this.textSize = 18,
      this.textColor = Colors.white,
      this.highlightColor = Colors.white,
      this.fontWeight = FontWeight.bold,
      required this.onPressed
    }
  );

  final String title;
  final double width;
  final double height;
  final double radius;
  final double textSize;
  final Color bgColor;
  final Color outlineColor;
  final Color textColor;
  final Color highlightColor;
  final FontWeight fontWeight;
  final Function() onPressed;

  @override
  _TextButtonAppState createState() => _TextButtonAppState();
}

class _TextButtonAppState extends State<TextButtonApp> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {widget.onPressed();},
      style: (widget.width == 0 || widget.height == 0) ?
      ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return widget.highlightColor;
          }
          return widget.textColor;
        }),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ) :
      TextButton.styleFrom(
          backgroundColor: widget.bgColor,
          minimumSize: Size(widget.width, widget.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: BorderSide(
              color: widget.outlineColor,
            ),
          ),
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          fontWeight: widget.fontWeight,
          fontSize: widget.textSize,
        )
      ),
    );
  }
}