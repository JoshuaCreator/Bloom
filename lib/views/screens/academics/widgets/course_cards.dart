import 'package:basic_board/configs/colour_config.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.schedules,
    required this.code,
    this.onTap,
  });
  final String title, code;
  final List<Widget> schedules;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: defaultBorderRadius,
      child: Ink(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        decoration: BoxDecoration(
          color: ColourConfig.lightGrey.withOpacity(0.5),
          borderRadius: defaultBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(code, style: const TextStyle(fontWeight: FontWeight.w500)),
            const Gap(20.0),
            Column(mainAxisSize: MainAxisSize.min, children: schedules),
          ],
        ),
      ),
    );
  }
}
