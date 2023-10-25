import 'package:flutter/material.dart';

class Sizes {
  static MediaQueryData? _mediaQuery;
  static double? height;
  static double? width;
  static double? defaultSize;
  static Orientation? _orientation;

  void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);

    height = _mediaQuery!.size.height;
    width = _mediaQuery!.size.width;
    defaultSize =
        _orientation == Orientation.landscape ? height! * 0.1 : width! * 0.1;
  }
}
