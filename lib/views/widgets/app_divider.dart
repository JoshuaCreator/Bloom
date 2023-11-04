import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    // final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // final Color color = brightness == Brightness.light ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(child: Divider()),
        SizedBox(width: ten),
        const Text('OR'),
        SizedBox(width: ten),
        const Flexible(child: Divider()),
      ],
    );
  }
}
