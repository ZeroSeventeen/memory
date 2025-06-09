import 'package:flutter/material.dart';
import 'package:memory/utils/game_style_handler.dart';

class AddPlayerDialog extends StatelessWidget {

  final Function(String value) onDone;
  String text = '';

  AddPlayerDialog({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Enter player name"),
      titleTextStyle: GameStyleHandler.textStyleReverse,
      content: TextField(
        onChanged: (text) => this.text = text,
        decoration: InputDecoration(
          hintText: 'Player name',
        ),
      ),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(
            onPressed: () {
              onDone(text);
              Navigator.of(context).pop();
            },
            child: Text("Apply")
        ),
      ],
    );
  }
}