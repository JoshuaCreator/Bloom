import 'package:flutter/material.dart';

import '../../../../configs/colour_config.dart';
import '../../../../configs/consts.dart';

class CourseInfoTile extends StatelessWidget {
  const CourseInfoTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: ColourConfig.lightGrey.withOpacity(0.2),
        borderRadius: defaultBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w300)),
          Text(value, style: const TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
