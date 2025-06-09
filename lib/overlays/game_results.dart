
import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:memory/utils/game_style_handler.dart';

import '../game/player.dart';
import '../ui_utils/memory_button.dart';

class GameResults extends StatelessWidget {
  const GameResults({super.key, required this.players, required this.onExit, required this.onReset});

  final UnmodifiableListView<Player> players;
  final VoidCallback onExit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Card(
            color: GameStyleHandler.backColor2,
            child: Column(
              children: [
                Text(
                  'Scores',
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'InknutAntiqua',
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder:
                        (context, index) => ListTile(
                      title: Text('${players[index].name}: ${players[index].score}'),
                      titleTextStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'InknutAntiqua',
                      ),
                    ),
                  ),
                ),
                Divider(),
                MemoryButton(
                    Vector2(200, 60),
                    text: 'Back to menu',
                    onPressed: onExit
                ),
                MemoryButton(
                    Vector2(200, 60),
                    text: 'Reset game',
                    onPressed: onReset
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}