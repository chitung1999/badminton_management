import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDown extends StatefulWidget {
  const DropDown({
    super.key,
    required this.items,
    required this.onChanged,
    this.width = 160,
    this.height = 40
  });

  final List<String> items;
  final double width;
  final double height;
  final Function(String) onChanged;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late String _value;

  @override
  void initState() {
    if(widget.items.isEmpty) {
      _value = '';
    } else {
      _value = widget.items[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      value: _value,
      isDense: true,
      buttonStyleData: ButtonStyleData(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.white70
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
      ),
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));}
      ).toList(),
      onChanged: (String? value) {
        setState(() {_value = value!;});
        widget.onChanged(_value);
      },
    );
  }
}
