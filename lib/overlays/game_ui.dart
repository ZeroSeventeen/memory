import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:memory/ui_utils/memory_button.dart';


class GameUI extends StatelessWidget {

  VoidCallback onGiveUp;
  VoidCallback onExit;

  GameUI({super.key, required this.onGiveUp, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Card(
            color: Color(0x00ffffff),
            child: Column(
              children: [
                MemoryButton(
                    Vector2(200, 60),
                    text: 'Give up',
                    onPressed: onGiveUp
                ),
                MemoryButton(
                    Vector2(200, 60),
                    text: 'Back to menu',
                    onPressed: onExit
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}