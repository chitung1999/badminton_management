import 'package:flutter/material.dart';

class ItemTable extends StatefulWidget {
  const ItemTable(
      {
        super.key,
        required this.titles,
        this.height = 40,
        this.bgColor = Colors.transparent,
        this.outlineColor = Colors.blueGrey,
        this.textColor = Colors.blueGrey,
        this.isHeader = false,
        this.onDoubleClick
      }
      );

  final List<String> titles;
  final double height;
  final Color bgColor;
  final Color outlineColor;
  final Color textColor;
  final bool isHeader;
  final Function()? onDoubleClick;

  @override
  _ItemTableState createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
  late Color _bgColor;
  @override
  void initState() {
    _bgColor = widget.bgColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderSide border = BorderSide(color: widget.outlineColor);

    return MouseRegion(
      onEnter: (_) {
        if(!widget.isHeader) {
          setState(() {_bgColor = Colors.blueGrey[50]!;});
        }
        },
      onExit: (_) {
        if(!widget.isHeader) {
          setState(() {
            _bgColor = widget.bgColor;
          });
        }
      },
      child: GestureDetector(
        onDoubleTap: () async {
          if(widget.onDoubleClick != null) {
            await widget.onDoubleClick!();
            setState(() {
              _bgColor = widget.bgColor;
            });
          }
        },
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _bgColor,
            border: Border(top: widget.isHeader ? border : BorderSide.none, left: border, right: border, bottom: border)
        ),
          child: Row(
            children: [
              for(int i = 0; i < widget.titles.length; i++)
                Expanded(child: Center(
                  child: Text(
                    widget.titles[i],
                    style: TextStyle(
                      fontSize: 15,
                      color: (i == 3 && widget.titles[i] == 'Chưa thu') ? Colors.red : widget.textColor,
                      fontWeight: widget.isHeader ? FontWeight.bold : FontWeight.normal
                    )
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}