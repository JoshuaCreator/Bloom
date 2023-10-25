import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.backgroundColour = Colors.black87,
    this.foregroundColour = Colors.white,
  });
  final Color backgroundColour;
  final Color foregroundColour;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(twenty),
        child: Container(
          constraints:
              BoxConstraints(maxHeight: size * 3.7, minWidth: size * 3.7),
          padding: EdgeInsets.all(thirty),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(twenty),
            color: backgroundColour,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: foregroundColour),
              height10,
              Text(
                'Getting things ready',
                style: TextStyle(fontSize: 16.0, color: foregroundColour),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
