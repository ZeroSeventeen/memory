import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:memory/game/cards_deck.dart';
import 'package:memory/menu/main_menu.dart';
import 'package:memory/settings.dart';
import 'package:memory/menu/settings_page.dart';
import 'package:memory/utils/cards_style_handler.dart';

import 'game/bot.dart';
import 'game/field.dart';
import 'game/game_background.dart';
import 'game/player.dart';
import 'overlays/score_tracker.dart';

class MemoryGame extends FlameGame {

  static const double cardGap = 175.0;
  static const double cardWidth36 = 615.0;
  static const double cardHeight36 = 862.0;
  static const double cardWidth16 = 1000.0;
  static const double cardHeight16 = 1400.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize36 = Vector2(cardWidth36, cardHeight36);
  static final Vector2 cardSize16 = Vector2(cardWidth16, cardHeight16);
  static final double strokeWidth16 = 35;
  static final double strokeWidth36 = 23;

  late final RouterComponent router;

  late CardsDeck _deck;
  late Field _field;
  final GlobalKey<ScoreTrackerState> trackerKey = GlobalKey();

  int _lastFlippedId = -1;
  int _lastFlippedInstance = -1;

  final List<Player> players = [];
  int _currentPlayerIndex = 0;

  int _flippedCount = 0;
  bool _isGameOver = false;


  @override
  FutureOr<void> onLoad() async{

    await _loadAssets();
    _setupRouter();
    _setupCamera();

    CardsStyleHandler.setIdColors(Settings.cardsNumber ~/ 2);
    CardsStyleHandler.setIdImages(Settings.cardsNumber ~/ 2);

    world.add(GameBackground());
    _deck = CardsDeck(onCardTap: handleFlip);
    _field = Field();
    _field.addCards(_deck.cards);
    world.add(_field);
  }

  void reset() {
    _resetState();
    hideOverlay(['results']);
    showOverlay(['scores', 'ui']);

    if (players[_currentPlayerIndex] is Bot) {
      _handleBotMove();
    }
  }

  void handleFlip(int cardId, int cardInstance) async{
    await Future.delayed(Duration(milliseconds: 500));

    int flippedPosition = _deck.getPosition(cardId, cardInstance);
    bool shouldContinueMove = false;

    for (int i = 0; i < players.length; i++) {
      if (players[i] is Bot) {
        (players[i] as Bot).registerId(flippedPosition, cardId);
        (players[i] as Bot).registerOpened(flippedPosition);
      }
    }

    if (_lastFlippedId == -1) {
      _lastFlippedId = cardId;
      _lastFlippedInstance = cardInstance;
    } else {
      if (_lastFlippedId == cardId) {
        players[_currentPlayerIndex].increaseScore();
        trackerKey.currentState?.updateScores();
        _flippedCount += 2;

        if (_flippedCount == Settings.cardsNumber) {
          _showResults();
          _isGameOver = true;
        }

        shouldContinueMove = true;

      } else {
        _deck.flipDown(_lastFlippedId, _lastFlippedInstance);
        _deck.flipDown(cardId, cardInstance);

        for (int i = 0; i < players.length; i++) {
          if (players[i] is Bot) {
            (players[i] as Bot).registerClosed(flippedPosition);
            (players[i] as Bot).registerClosed(_deck.getPosition(_lastFlippedId, _lastFlippedInstance));
          }
        }

        _changeTurn();
      }

      _lastFlippedId = -1;
      _lastFlippedInstance = -1;
    }

    if (shouldContinueMove && players[_currentPlayerIndex] is Bot) {
      _handleBotMove();
    }
  }

  void _changeTurn() async {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % players.length;
    trackerKey.currentState?.updateCurrentPlayer(_currentPlayerIndex);

    if (players[_currentPlayerIndex] is Bot) {
      _handleBotMove();
    }
  }

  void _handleBotMove() async {
    if (_isGameOver) {
      return;
    }

    var positions = await (players[_currentPlayerIndex] as Bot).makeMove();

    _deck.flipCardOnPosition(positions.$1);
    await Future.delayed(Duration(milliseconds: 500));
    _deck.flipCardOnPosition(positions.$2);
    await Future.delayed(Duration(milliseconds: 500));
  }

  FutureOr<void> _loadAssets() async {
    await Flame.images.load('logo.jpg');
    await Flame.images.load('logo_blanc.png');
    await Flame.images.load('back.jpg');

    await Flame.images.loadAll(CardsStyleHandler.pictures);
  }

  void _setupRouter() {
    add(
      router = RouterComponent(
        routes: {
          'menu': Route(MainMenu.new),
          'settings': Route(SettingsPage.new),
          'game': WorldRoute(() => world)
        },
        initialRoute: 'menu',
      ),
    );
  }

  void _setupCamera() {
    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth16 * sqrt(Settings.cardsNumber) + cardGap * (sqrt(Settings.cardsNumber) + 1),
            cardHeight16 * sqrt(Settings.cardsNumber) + cardGap * (sqrt(Settings.cardsNumber) + 1));
    camera.viewfinder.position = Vector2((camera.viewfinder.visibleGameSize?.x ?? 0) / 2, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  void giveUp() {
    players[_currentPlayerIndex].resetScore();
    _showResults();
  }

  void exit() {
    players.clear();
    router.pushNamed('menu');
    hideOverlay(['scores', 'results', 'ui']);
    _resetState();
  }

  void _resetState() {
    CardsStyleHandler.setIdColors(Settings.cardsNumber ~/ 2);
    CardsStyleHandler.setIdImages(Settings.cardsNumber ~/ 2);
    CardsStyleHandler.setIdGradients(Settings.cardsNumber ~/ 2);

    world.remove(_field);
    _deck = CardsDeck(onCardTap: handleFlip);
    _field = Field();
    _field.addCards(_deck.cards);
    world.add(_field);

    for (int i = 0; i < players.length; i++) {
      players[i].resetScore();
    }

    _currentPlayerIndex = 0;
    trackerKey.currentState?.updateCurrentPlayer(_currentPlayerIndex);

    _flippedCount = 0;
    _isGameOver = false;
  }

  void showOverlay(List<String> values) {

    for (int i = 0; i < values.length; i++) {
      if (!overlays.isActive(values[i])) {
        overlays.add(values[i]);
      }
    }
  }

  void hideOverlay(List<String> values) {

    for (int i = 0; i < values.length; i++) {
      if (overlays.isActive(values[i])) {
        overlays.remove(values[i]);
      }
    }
  }

  void _showResults() {
    hideOverlay(['scores', 'ui']);
    showOverlay(['results']);
  }

  void addPlayer(String name) {
    players.add(Player(name: name));
  }

  void addBot(String name, int intelligence) {
    players.add(Bot(intelligence, name: name));
  }

  void openGame() {
    reset();
    router.pushNamed('game');
    hideOverlay(['settings']);
  }
}