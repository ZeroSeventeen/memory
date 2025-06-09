import 'package:flutter/material.dart';
import 'package:memory/utils/game_style_handler.dart';

class AddBotDialog extends StatefulWidget {

  final Function(String name, int intelligence) onDone;

  const AddBotDialog({super.key, required this.onDone});

  @override
  State<AddBotDialog> createState() => _AddBotDialogState();
}

class _AddBotDialogState extends State<AddBotDialog> {
  String text = '';

  int intelligence = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titleTextStyle: GameStyleHandler.textStyle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "Bot name",
              style: GameStyleHandler.textStyleReverse,
          ),
          TextField(
            onChanged: (text) => this.text = text,
            decoration: InputDecoration(
              hintText: 'Bot name',
            ),
          ),
          Divider(
            color: Color(0x00ffffff)
          ),
          Text(
              "Bot intelligence",
              style: GameStyleHandler.textStyleReverse,
          ),
          Slider(
            min: 0.0,
            max: 100.0,
            value: intelligence.toDouble(),
            divisions: 10,
            label: '${intelligence.round()}',
            activeColor: GameStyleHandler.backColor,
            inactiveColor: GameStyleHandler.backColor2,
            onChanged: (value) {
              setState(() {
                intelligence = value.round();
              });
            },
          )
        ],
      ),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(
            onPressed: () {
              widget.onDone(text, intelligence);
              Navigator.of(context).pop();
            },
            child: Text("Apply")
        ),
      ],
    );
  }
}