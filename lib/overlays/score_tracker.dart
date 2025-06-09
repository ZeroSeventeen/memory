import 'dart:collection';

import 'package:flutter/material.dart';

import '../game/player.dart';
import '../utils/game_style_handler.dart';

class ScoreTracker extends StatefulWidget {

  final UnmodifiableListView<Player> players;

  const ScoreTracker({required this.players, super.key});

  @override
  State<StatefulWidget> createState() => ScoreTrackerState();
}

class ScoreTrackerState extends State<ScoreTracker> {

  int _currentPlayerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Card(
            color: Color(0x99FFFFFF),
            child: Column(
              children: [
                Text(
                  'Scores',
                  style: GameStyleHandler.textStyleHeader2,
                ),
                Divider(),
                Flexible(
                  child: ListView.builder(
                    itemCount: widget.players.length,
                    itemBuilder:
                        (context, index) => ListTile(
                      title: Text('${widget.players[index].name}: ${widget.players[index].score}'),
                      titleTextStyle: (index == _currentPlayerIndex)
                          ? GameStyleHandler.textStyleHeader3Reverse
                          : GameStyleHandler.textStyleHeader3
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateScores() => setState(() {});

  void updateCurrentPlayer(int currentPlayerIndex) => setState(() {
    _currentPlayerIndex = currentPlayerIndex;
  });

}
