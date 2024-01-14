import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../configs/colour_config.dart';
import '../../../../configs/consts.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });
  final Widget icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: defaultBorderRadius,
      child: Ink(
        width: double.maxFinite,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: defaultBorderRadius,
          border: Border.all(
            color: ColourConfig.lightGrey.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const Gap(10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
