import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory/memory_game.dart';
import 'package:memory/utils/game_style_handler.dart';

import '../ui_utils/background.dart';
import '../ui_utils/rounded_button.dart';

class MainMenu extends Component with HasGameReference<MemoryGame>{

  late final TextComponent _logo;
  late final RoundedButton _buttonStart;

  MainMenu() {
    addAll([
      Background(),
      _logo = TextComponent(
        text: 'Memory',
        textRenderer: TextPaint(
          style: GameStyleHandler.textStyleHeader1,
        ),
        anchor: Anchor.center,
      ),
      _buttonStart = RoundedButton(
        text: 'New game',
        action: () => openSettings(),
        color: const Color(0xff7e0077),
        borderColor: const Color(0xffffffff),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _buttonStart.position = Vector2(size.x / 2, _logo.y + 100);
  }

  void openSettings() {
    game.router.pushNamed('settings');
    game.showOverlay(['settings']);
  }
}
