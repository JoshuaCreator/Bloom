import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider(
      {super.key, this.onTap, required this.turns, required this.title});
  final void Function()? onTap;
  final double turns;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(ten),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedRotation(
              turns: turns,
              duration: Duration(milliseconds: animationDuration),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
