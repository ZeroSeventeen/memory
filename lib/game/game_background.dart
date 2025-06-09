import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:memory/memory_game.dart';

class GameBackground extends SpriteComponent with HasGameReference<MemoryGame> {

 GameBackground() {
    sprite = Sprite(Flame.images.fromCache('back.jpg'));
  }

  @override
 FutureOr<void> onLoad() {
   position = Vector2(-1 * (game.camera.viewfinder.visibleGameSize?.x ?? 0), 0);
   size = Vector2(
       3 * (game.camera.viewfinder.visibleGameSize?.x ?? 0),
       game.camera.viewfinder.visibleGameSize?.y ?? 0
   );
 }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    size = Vector2(
        3 * (game.camera.viewfinder.visibleGameSize?.x ?? 0),
        game.camera.viewfinder.visibleGameSize?.y ?? 0
    );
  }
}