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
}
