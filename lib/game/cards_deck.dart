import 'dart:math';

import 'package:memory/memory_game.dart';
import 'package:memory/settings.dart';

import 'card.dart';


class CardsDeck {

  final List<Card> _cards = [];
  final Random _random = Random();
  final Function(int id, int instance) onCardTap;

  CardsDeck({required this.onCardTap}) {
    setupCards();
  }

  List<Card> get cards => List.unmodifiable(_cards);

  void setupCards() {
    var cardSize = (Settings.cardsNumber == 16) ? MemoryGame.cardSize16 : MemoryGame.cardSize36;

    for (int i = 0; i < Settings.cardsNumber ~/ 2; i++) {
      var newCardFirst = Card(id: i, instance: 1, size: cardSize, onFaceUp: onCardTap);
      var newCardSecond = Card(id: i, instance: 2, size: cardSize, onFaceUp: onCardTap);

      if (_cards.isEmpty) {
        _cards.add(newCardFirst);
      } else {
        _cards.insert(_random.nextInt(_cards.length), newCardFirst);
      }

      _cards.insert(_random.nextInt(_cards.length), newCardSecond);
    }
  }

  void flipDown(int cardId, int cardInstance) {
    for (int i = 0; i < _cards.length; i++) {
      if (_cards[i].id == cardId && _cards[i].instance == cardInstance) {
        _cards[i].flipFaceDown();
        break;
      }
    }
  }

  int getPosition(int id, int instance) {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].id == id && cards[i].instance == instance) {
        return i;
      }
    }

    return -1;
  }

  void flipCardOnPosition(int position) {
    cards[position].flipFaceUp();
  }

}