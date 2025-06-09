import 'dart:async';

import 'package:flame/components.dart';
import '../memory_game.dart';
import '../ui_utils/background.dart';

class SettingsPage extends Component with HasGameReference<MemoryGame>{

  @override
  FutureOr<void> onLoad() {
    add(Background());
  }
}