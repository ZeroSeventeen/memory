import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:memory/memory_game.dart';
import 'package:memory/utils/card_style.dart';
import 'package:memory/utils/cards_style_handler.dart';

import '../settings.dart';

class Card extends PositionComponent with TapCallbacks {

  final int id;
  final int instance;
  bool _isFaceUp = false;
  Vector2 _cardSize = Vector2(0, 0);

  final Paint _borderPaint1 = Paint()
    ..color = const Color(0xffffffff)
    ..style = PaintingStyle.stroke;

  final Paint _borderPaint2 = Paint()
    ..color = const Color(0xACF38484)
    ..style = PaintingStyle.stroke;

  late final RRect _cardRRect;
  late final RRect _backRRectInner;


  Function(int id, int instance) onFaceUp;

  bool get isFaceUp => _isFaceUp;
  bool get isFaceDown => !_isFaceUp;

  Card({required this.id, required this.instance, required super.size, required this.onFaceUp}) {
    _cardSize = (Settings.cardsNumber == 16) ? MemoryGame.cardSize16 : MemoryGame.cardSize36;
    _borderPaint1.strokeWidth = (Settings.cardsNumber == 16)
        ? MemoryGame.strokeWidth16
        : MemoryGame.strokeWidth36;
    _borderPaint2.strokeWidth = (Settings.cardsNumber == 16)
        ? MemoryGame.strokeWidth16
        : MemoryGame.strokeWidth36;

    _cardRRect = RRect.fromRectAndRadius(
      _cardSize.toRect(),
      const Radius.circular(MemoryGame.cardRadius),
    );
    _backRRectInner = _cardRRect.deflate(_borderPaint1.strokeWidth / 1.15);
  }

  void flipFaceUp() {
    if (_isFaceUp) {
      return;
    }

    turnFaceUp();
    _isFaceUp = !_isFaceUp;
    onFaceUp(id, instance);
  }

  void flipFaceDown() {
    if (!_isFaceUp) {
      return;
    }

    turnFaceUp();
    _isFaceUp = !_isFaceUp;
  }

  @override
  void render(Canvas canvas) {
    if (_isFaceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  void _renderFront(Canvas canvas) {

    switch(Settings.cardsStyle) {
      case CardStyle.monoColor:
        canvas.drawRRect(_cardRRect, Paint()..color = CardsStyleHandler.getColorById(id));
        break;
      case CardStyle.image:
        Sprite sprite = CardsStyleHandler.getSpriteById(id);
        sprite.render(canvas, position: size / 2, size: size - Vector2.all(35), anchor: Anchor.center);
        canvas.drawRRect(_cardRRect, _borderPaint1);
        canvas.drawRRect(_backRRectInner, _borderPaint2);
        break;
      case CardStyle.gradient:
        var paint = Paint()
          ..shader = ui.Gradient.linear(
            Offset(size.x / 3, size.y / 3),
            Offset(2 * size.x / 3, 2 * size.y / 3),
            [
              CardsStyleHandler.getGradientById(id).$1,
              CardsStyleHandler.getGradientById(id).$2,
            ],
          );
        canvas.drawRRect(_cardRRect, paint);
        break;
    }
  }

  void _renderBack(Canvas canvas) {
    Sprite logoSprite = Sprite(Flame.images.fromCache('logo.jpg'));

    logoSprite.render(canvas, position: size / 2, size: size - Vector2.all(35), anchor: Anchor.center);
    canvas.drawRRect(_cardRRect, _borderPaint1);
    canvas.drawRRect(_backRRectInner, _borderPaint2);
  }


  @override
  void onTapDown(TapDownEvent event) {
    flipFaceUp();
  }

  void turnFaceUp({
    double time = 0.3,
    double start = 0.0,
  }) {
    anchor = Anchor.topCenter;
    position += Vector2(width / 2, 0);
    priority = 100;
    add(
      ScaleEffect.to(
        Vector2(scale.x / 100, scale.y),
        EffectController(
          startDelay: start,
          curve: Curves.easeOutSine,
          duration: time / 2,
          reverseDuration: time / 2,
          onMin: () {
            anchor = Anchor.topLeft;
            position -= Vector2(width / 2, 0);
          },
        ),
      ),
    );
  }
}