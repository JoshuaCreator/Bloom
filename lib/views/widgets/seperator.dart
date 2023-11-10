import 'package:flutter/material.dart';

class Seperator extends StatelessWidget {
  const Seperator({
    super.key,
    this.height = 20,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: 2.0,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
