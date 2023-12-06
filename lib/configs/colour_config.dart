import 'package:flutter/material.dart';

class ColourConfig {
  static Color foregroundColour(Brightness brightness, {bool isBuild = false}) {
    if (isBuild && brightness == Brightness.dark) {
      return Colors.black87;
    } else if (isBuild && brightness == Brightness.light) {
      return Colors.white;
    } else if (!isBuild && brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Colors.black87;
    }
  }

  static Color backgroundColour(Brightness brightness, {bool isBuild = false}) {
    if (isBuild && brightness == Brightness.dark) {
      return Colors.white;
    } else if (isBuild && brightness == Brightness.light) {
      return Colors.black87;
    } else if (!isBuild && brightness == Brightness.light) {
      return Colors.black87;
    } else {
      return Colors.white;
    }
  }

  static Color danger = Colors.red;

  static Color go = Colors.green;

  static Color grey = Colors.grey;

  static Color white = Colors.white;

  static Color black = Colors.black;

  static Color fadedBlack = Colors.black87;

  static Color empty = Colors.transparent;
}
