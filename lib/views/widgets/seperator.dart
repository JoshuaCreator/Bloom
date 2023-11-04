import 'package:flutter/material.dart';

class Seperator extends StatelessWidget {
  const Seperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 20,
      thickness: 2.0,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
