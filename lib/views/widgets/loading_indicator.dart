import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    // this.backgroundColour = Colors.black87,
    // this.foregroundColour = Colors.white,
    this.isBuild = false,
  });
  // final Color backgroundColour;
  // final Color foregroundColour;
  final bool isBuild;

  Color foregroundColour(Brightness brightness) {
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

  Color backgroundColour(Brightness brightness) {
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

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(twenty),
        child: Container(
          constraints:
              BoxConstraints(maxHeight: size * 3.7, minWidth: size * 3.7),
          padding: EdgeInsets.all(thirty),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(twenty),
            color: backgroundColour(brightness),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: foregroundColour(brightness),
              ),
              height10,
              Text(
                'Getting things ready',
                style: TextStyle(
                  fontSize: 16.0,
                  color: foregroundColour(brightness),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
