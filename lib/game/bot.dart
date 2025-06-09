
import 'dart:math';

import 'package:memory/game/player.dart';
import 'package:memory/settings.dart';
import 'package:memory/utils/bot_card_model.dart';

class Bot extends Player {

  static final Random _random = Random();
  static int moveNum = 0;
  final int intelligenceRate;

  final List<BotCardModel> _cardModels = [];

  Bot(this.intelligenceRate, {required super.name}) {
    resetScore();
  }

  Future<(int, int)> makeMove() async {
    var pair = tryFindPair();
    await Future.delayed(Duration(milliseconds: 500));

    if (pair.$1 != -1 && _random.nextInt(100) < intelligenceRate) {
      return pair;
    } else {
      int first = _getRandomCardToFlip();
      int second = first;

      while (second == first) {
        second = _getRandomCardToFlip();
      }

      return (first, second);
    }
  }

  (int, int) tryFindPair() {
    for (int i = 0; i < _cardModels.length - 1; i++) {
      for (int j = i + 1; j < _cardModels.length; j++) {
        if (_cardModels[i].id != -1 && _cardModels[j].id != -1 &&
            _cardModels[i].id == _cardModels[j].id &&
            !_cardModels[i].isOpened && !_cardModels[i].isOpened
        ) {
          return (i, j);
        }
      }
    }

    return (-1, -1);
  }

  int _getRandomCardToFlip() {
    int attemptsCounter = 50;
    int position = 0;

    for (int i = 0; i < attemptsCounter; i++) {
      position = _random.nextInt(_cardModels.length);

      if (!_cardModels[position].isOpened) {
        return position;
      }
    }

    for (int i = 0; i < _cardModels.length; i++) {
      if (!_cardModels[i].isOpened) {
        return i;
      }
    }

    return -1;
  }

  void resetModel() {
    _cardModels.clear();

    for (int i = 0; i < Settings.cardsNumber; i++) {
      _cardModels.add(BotCardModel(number: i));
    }
  }

  @override
  void resetScore() {
    super.resetScore();
    resetModel();
  }

  void registerId(int position, int id) {
    _cardModels[position].id = id;
  }

  void registerOpened(int position) {
    _cardModels[position].isOpened = true;
  }

  void registerClosed(int position) {
    _cardModels[position].isOpened = false;
  }
}