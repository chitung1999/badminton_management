import 'package:badminton_management/database/database.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key, required this.onSelected});

  final Function(String) onSelected;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _value = dataModel.time[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      value: _value,
      isDense: true,
      buttonStyleData: ButtonStyleData(
        height: 50,
        width: 160,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.blueGrey),
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
      items: dataModel.time.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));}
      ).toList(),
      onChanged: (String? value) {
        setState(() {
          _value = value!;
          widget.onSelected(_value);
        });
      },
    );
  }
}
