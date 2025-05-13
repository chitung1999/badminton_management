import 'package:badminton_management/provider/data_provider.dart';
import 'package:badminton_management/provider/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

class DropDown extends StatefulWidget {
  const DropDown({
    super.key,
  });

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Consumer2<DataProvider, FilterProvider>(
      builder: (context, data, date, chill) {
        List<String> items = data.getListTime();

        if (items.isNotEmpty && !items.contains(_value)) {
          _value = items[0];
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_value == items[0] && date.getTime() != null) {
            date.setTime(_value);
          }
        });

        return DropdownButton2(
          value: _value,
          isDense: true,
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: 160,
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
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));}
          ).toList(),
          onChanged: (String? value) {
            setState(() {_value = value!;});
            date.setTime(_value);
          },
        );
      }
    );
  }
}
