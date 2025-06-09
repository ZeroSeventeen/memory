import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class CardsStyleHandler {

  static final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.tealAccent,
    Colors.orange,
    Color(0xffffd9d9),
    Color(0xff97c100),
    Color(0xffbdfbc0),
    Color(0xfffbf8bd),
    Color(0xffbde1fb),
    Color(0xffdfbdfb),
    Color(0xFFAE0041),
    Color(0xFFC67600),
    Color(0xFFB3B1B1),
    Color(0xFFDDFF01),
    Color(0xFF58C585),
    Color(0xFFF3A4C2),
  ];
  static final List<String> pictures = [
    'cat_01.jpg',
    'cat_02.jpg',
    'cat_03.jpg',
    'cat_04.jpg',
    'cat_05.jpg',
    'cat_06.jpg',
    'cat_07.jpg',
    'cat_08.jpg',
    'cat_09.jpg',
    'cat_10.jpg',
    'cat_11.jpg',
    'cat_12.jpg',
    'cat_13.jpg',
    'cat_14.jpg',
    'cat_15.jpg',
    'cat_16.jpg',
    'cat_17.jpg',
    'cat_18.jpg',
  ];

  static final Map<int, Color> _colorsById = {};
  static final Map<int, Sprite> _imagesById = {};
  static final Map<int, (Color, Color)> _gradientById = {};

  static void setIdColors(int maxId) {
    for (int i = 0; i < maxId; i++) {
      _colorsById[i] = _colors[i];
    }
  }

  static void setIdImages(int maxId) {
    for (int i = 0; i < maxId; i++) {
      _imagesById[i] = Sprite(Flame.images.fromCache(pictures[i]));
    }
  }

  static void setIdGradients(int maxId) {
    var random = Random();
    int index = 0;

    for (int i = 0; i < maxId; i++) {
      index = i;

      while (index == i) {
        index = random.nextInt(_colors.length);
      }

      _gradientById[i] = (_colors[i], _colors[index]);
    }
  }

  static Color getColorById(int id) => _colorsById[id] ?? Colors.brown;

  static Sprite getSpriteById(int id) => _imagesById[id] ?? Sprite(Flame.images.fromCache(pictures[0]));

  static (Color, Color) getGradientById(int id) => _gradientById[id] ?? (Colors.black, Colors.white);
}