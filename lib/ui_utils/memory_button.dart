import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory/utils/game_style_handler.dart';

class MemoryButton extends StatelessWidget {

  void Function()? onPressed;
  String text;
  Vector2 realSize = Vector2.all(0);

  MemoryButton(Vector2 size, {super.key, required this.text, required this.onPressed}) {
    realSize = size;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: realSize.x,
          height: realSize.y,
          child: Card(
            color: GameStyleHandler.backColor,
            child: Center(
              child: Text(
                text,
                style: GameStyleHandler.textStyle,
                textAlign: TextAlign.center,
              ),
            )
          ),
        ),
    );
  }
}