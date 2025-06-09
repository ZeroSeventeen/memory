import 'dart:math';

import 'package:flame/components.dart';
import 'package:memory/memory_game.dart';
import 'package:memory/settings.dart';

import 'card.dart';


class Field extends PositionComponent {

  void addCards(List<Card> cards) {
    var cardWidth = (Settings.cardsNumber == 16) ? MemoryGame.cardWidth16 : MemoryGame.cardWidth36;
    var cardHeight = (Settings.cardsNumber == 16) ? MemoryGame.cardHeight16 : MemoryGame.cardHeight36;

    int gridSize = sqrt(Settings.cardsNumber).round();
    int gridX = 0;
    int gridY = 0;

    for (int i = 0; i < cards.length; i++) {
      gridX = (i % gridSize) + 1;
      gridY = (i ~/ gridSize) + 1;

      cards[i].position = Vector2(
          gridX * MemoryGame.cardGap + (gridX - 1) * cardWidth,
          gridY * MemoryGame.cardGap + (gridY - 1) * cardHeight
      );
      add(cards[i]);
    }
  }
}