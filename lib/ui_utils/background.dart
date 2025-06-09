import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:memory/memory_game.dart';

class Background extends SpriteComponent with HasGameReference<MemoryGame> {

  Background() {
    sprite = Sprite(Flame.images.fromCache('back.jpg'));
  }

  @override
  FutureOr<void> onLoad() {
    size = game.size;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    this.size = game.size;
  }
}