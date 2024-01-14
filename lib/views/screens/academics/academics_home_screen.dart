import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/views/screens/academics/courses_screen.dart';
import 'package:basic_board/views/screens/academics/events_screen.dart';
import 'package:basic_board/views/screens/academics/lectures_screen.dart';
import 'package:basic_board/views/screens/academics/performance_report_screen.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'courseworks_screen.dart';
import 'widgets/activity_card.dart';
import 'widgets/profile_card.dart';

class AcademicsHomeScreen extends ConsumerWidget {
  static String id = 'academics-home';
  const AcademicsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Academics')),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          ProfileCard(
            studentId: user?['studentId'] ?? 'N/A',
            name: user?['name'] ?? 'N/A',
            intake: (user?['isStaff'] ?? false)
                ? 'Staff'
                : user?['intake'] == null
                    ? 'N/A'
                    : '${DateFormat('MMM yyyy').format((user?['intake']).toDate())} intake',
            image: user?['image'] ?? defaultUserImgPath,
            onTap: () {
              // TODO: Do something
            },
          ),
          const Gap(20.0),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            children: [
              ActivityCard(
                icon: const Icon(Icons.school_rounded, size: 55),
                title: 'Courses',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${CoursesScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.schedule_rounded, size: 55),
                title: 'Lectures',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${LecturesScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.assignment_rounded, size: 55),
                title: 'Courseworks',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${CourseworksScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.assessment_rounded, size: 55),
                title: 'Performance/Report',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${PerformanceReportScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.event_rounded, size: 55),
                title: 'Events',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${EventsScreen.id}',
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
