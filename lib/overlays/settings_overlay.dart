import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:memory/overlays/add_player_dialog.dart';
import 'package:memory/ui_utils/memory_button.dart';
import 'package:memory/utils/game_style_handler.dart';

import '../game/player.dart';
import '../settings.dart';
import '../ui_utils/dropdown.dart';
import '../utils/card_style.dart';
import 'add_bot_dialog.dart';

class SettingsOverlay extends StatefulWidget {

  final UnmodifiableListView<Player> players;
  final Function(String name) onAddPlayer;
  final Function(String name, int intelligence) onAddBot;
  final VoidCallback onApplyChanges;

  const SettingsOverlay({
    required this.players,
    super.key,
    required this.onAddPlayer,
    required this.onAddBot,
    required this.onApplyChanges
  });

  @override
  State<StatefulWidget> createState() => SettingsOverlayState();
}

class SettingsOverlayState extends State<SettingsOverlay> {

  final List<String> _addedPlayers = [];
  bool _canApply = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Card(
            color: Color(0x99ffffff),
            child: Column(
              children: [
                Text(
                  'Setup',
                  style: GameStyleHandler.textStyleHeader2,
                ),
                Text(
                  'Cards number',
                  style: GameStyleHandler.textStyleHeader3,
                ),
                Dropdown(
                  values: ['16', '36'],
                  onValueChanged: (value) => Settings.cardsNumber = int.parse(value),
                ),
                Text(
                  'Cards style',
                  style: GameStyleHandler.textStyleHeader3,
                ),
                Dropdown(
                  values: ['Colors', 'Gradient', 'Pictures'],
                  onValueChanged: (value) => Settings.cardsStyle = _stringToStyle(value),
                ),
                Text(
                  'Players',
                  style: GameStyleHandler.textStyleHeader3,
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: widget.players.length,
                    itemBuilder:
                    (context, index) => ListTile(
                      title: Text(_addedPlayers[index]),
                      titleTextStyle: GameStyleHandler.textStyleLow,
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MemoryButton(
                        Vector2(120, 60),
                        text: '+ Player',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddPlayerDialog(onDone: _addPlayer);
                              }
                          );
                          setState(() {});
                        }
                    ),
                    MemoryButton(
                        Vector2(120, 60),
                        text: '+ Bot',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                _canApply = true;
                                return AddBotDialog(onDone: _addBot);
                              }
                          );
                          setState(() {});
                        }
                    ),
                  ],
                ),
                MemoryButton(
                    Vector2(200, 60),
                    text: 'Apply changes',
                    onPressed: _applyChanges
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addPlayer(String name) {
    setState(() {
      _addedPlayers.add('$name: human');
      _canApply = true;
    });
    widget.onAddPlayer(name);
  }

  void _addBot(String name, int intelligence) {
    setState(() {
      _addedPlayers.add('$name: bot');
      _canApply = true;
    });
    widget.onAddBot(name, intelligence);
  }

  void _applyChanges() {

    if (_canApply) {
      widget.onApplyChanges();
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'You should add at least one player to start the game',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  CardStyle _stringToStyle(String string) {
    switch (string) {
      case 'Colors':
        return CardStyle.monoColor;
      case 'Gradient':
        return CardStyle.gradient;
      default:
        return CardStyle.image;
    }
  }
}