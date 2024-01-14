import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/connection_state.dart';
import '../../../dialogues/snack_bar.dart';
import '../../../widgets/app_text_buttons.dart';
import '../courses_screen.dart';
import '../widgets/course_info_tile.dart';

class CourseDetailsDialogue extends StatelessWidget {
  const CourseDetailsDialogue({
    super.key,
    required this.id,
    required this.title,
    required this.code,
    required this.desc,
    required this.lecturer,
  });
  final String id, title, code, desc, lecturer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              const Text('Course details', style: TextStyle(fontSize: 18.0)),
              Expanded(
                  child: AppTextButton(
                label: 'Delete',
                onPressed: () async {
                  final bool online = await isOnline();
                  if (!online) {
                    if (context.mounted) {
                      context.pop();
                      showSnackBar(
                        context,
                        msg:
                            "You're offline! Turn on wifi or mobile data to continue.",
                      );
                    }
                    return;
                  }
                  if (context.mounted) {
                    deleteCourse(context, id: id)
                        .then((value) => context.pop());
                  }
                },
              )),
            ],
          ),
          const Gap(20.0),
          CourseInfoTile(title: 'Course title', value: title),
          const Gap(10.0),
          CourseInfoTile(title: 'Course code', value: code),
          const Gap(10.0),
          CourseInfoTile(title: 'Course description', value: desc),
          const Gap(10.0),
          CourseInfoTile(title: 'Course lecturer', value: lecturer),
        ],
      ),
    );
  }
}
