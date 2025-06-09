import 'dart:collection';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:memory/memory_game.dart';
import 'package:memory/overlays/game_results.dart';
import 'package:memory/overlays/game_ui.dart';
import 'package:memory/overlays/score_tracker.dart';
import 'package:memory/overlays/settings_overlay.dart';

Future<void> main() async {

  final game = MemoryGame();
  runApp(MaterialApp(
      home: GameWidget(
        game: game,
        overlayBuilderMap: {
          'scores': (context, _) =>
              ScoreTracker(
                  key: game.trackerKey,
                  players: UnmodifiableListView(game.players)
              ),
          'ui': (context, _) =>
              GameUI(
                  onGiveUp: game.giveUp,
                  onExit: game.exit
              ),
          'results': (context, _) =>
              GameResults(
                  players: UnmodifiableListView(game.players),
                  onExit: game.exit,
                  onReset: game.reset
              ),
          'settings': (context, _) =>
              SettingsOverlay(
                players: UnmodifiableListView(game.players),
                onAddPlayer: game.addPlayer,
                onAddBot: game.addBot,
                onApplyChanges: game.openGame,
              ),
        },
      )
  ));
}
