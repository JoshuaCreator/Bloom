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

  static Color dull = Colors.grey;

  static Color holy = Colors.white;

  static Color evil = Colors.black;

  static Color empty = Colors.transparent;
}
