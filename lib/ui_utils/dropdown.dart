import 'package:flutter/material.dart';
import 'package:memory/utils/game_style_handler.dart';

class Dropdown extends StatefulWidget {
  
  final List<String> values;
  final Function(String value) onValueChanged;
  
  Dropdown({super.key, required this.values, required this.onValueChanged}) {}

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {

  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.values.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _dropdownValue,
      menuWidth: 200,
      items: widget.values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
              value,
            style: GameStyleHandler.textStyleLowReverse
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _dropdownValue = value!;
          widget.onValueChanged(value);
        });
      },
    );
  }
}