import 'package:flutter/material.dart';

class MenuAnchorItem extends StatefulWidget {
  const MenuAnchorItem({super.key, required this.text, required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  State<MenuAnchorItem> createState() => _MenuAnchorItemState();
}

class _MenuAnchorItemState extends State<MenuAnchorItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 50,
      child: MenuItemButton(
          child: Text(widget.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)),
          onPressed: () {widget.onPressed();}
      ),
    );
  }
}