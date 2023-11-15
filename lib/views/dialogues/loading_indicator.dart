import 'package:basic_board/configs/colour_config.dart';
import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.isBuild = false,
    this.label = 'Loading...',
  });
  final bool isBuild;
  final String label;

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
            color: ColourConfig.backgroundColour(brightness),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: ColourConfig.foregroundColour(brightness),
              ),
              height10,
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  color: ColourConfig.foregroundColour(brightness),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
