import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../dialogues/snack_bar.dart';
import 'dialogues/course_details_dialogue.dart';
import 'providers/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dialogues/loading_indicator.dart';
import 'widgets/add_course_dialogue.dart';
import 'widgets/course_cards.dart';

class CoursesScreen extends ConsumerWidget {
  static String id = 'courses';
  CoursesScreen({super.key});

  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseDescController = TextEditingController();
  final TextEditingController courseLecturerController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            onPressed: () async {
              final bool online = await isOnline();
              if (!online) {
                if (context.mounted) {
                  showSnackBar(
                    context,
                    msg:
                        "You're offline! Turn on wifi or mobile data to continue.",
                  );
                }
                return;
              }
              if (context.mounted) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddCourseDialogue(
                      titleController: courseTitleController,
                      codeController: courseCodeController,
                      descController: courseDescController,
                      lecturerController: courseLecturerController,
                      onAdd: () {
                        addCourse(
                          context,
                          title: courseTitleController.text.trim(),
                          code: courseCodeController.text.trim(),
                          desc: courseDescController.text.trim(),
                          lecturer: courseLecturerController.text.trim(),
                        ).then((value) => context.pop());
                      },
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
          )
        ],
      ),
      body: courses.when(
        data: (data) {
          return data.isEmpty
              ? const Center(child: Text('Manage your semester courses here'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      title: data[index]['title'] ?? 'N/A',
                      code: data[index]['code'] ?? 'N/A',
                      schedules: [],
                      // schedules: List.generate(
                      //   data[index]['schedules'].length ?? 0,
                      //   (i) => Padding(
                      //     padding: const EdgeInsets.only(bottom: 10.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         const Icon(Icons.schedule_rounded),
                      //         const Gap(10.0),
                      //         Text(data[index]['schedule'][i] ?? ''),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return CourseDetailsDialogue(
                              id: data[index].id,
                              title: data[index]['title'] ?? 'N/A',
                              code: data[index]['code'] ?? 'N/A',
                              desc: data[index]['desc'] ?? 'N/A',
                              lecturer: data[index]['lecturer'] ?? 'N/A',
                            );
                          },
                        );
                      },
                    );
                  },
                );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('An error occurred'));
        },
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}

Future<void> addCourse(
  BuildContext context, {
  required String title,
  required String code,
  required String desc,
  required String lecturer,
}) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  if (context.mounted) showLoadingIndicator(context);
  try {
    firestore.collection('users').doc(user?.uid).collection('courses').add({
      'title': title,
      'code': code,
      'desc': desc,
      'lecturer': lecturer,
    }).then((value) {
      context.pop();
      showSnackBar(context, msg: 'Course added successfully');
    });
  } catch (e) {
    if (context.mounted) {
      context.pop();
      showSnackBar(context, msg: 'Something unexpected happened. Try again');
    }
  }
}

Future<void> deleteCourse(BuildContext context, {required String id}) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final bool online = await isOnline();
  if (context.mounted) showLoadingIndicator(context);
  try {
    if (!online) {
      if (context.mounted) {
        showSnackBar(
          context,
          msg: "You're offline! Turn on wifi or mobile data to continue.",
        );
      }
      return;
    }
    firestore
        .collection('users')
        .doc(user?.uid)
        .collection('courses')
        .doc(id)
        .delete()
        .then((value) {
      showSnackBar(context, msg: 'Course deleted');
    });
  } catch (e) {
    if (context.mounted) {
      context.pop();
      showSnackBar(context, msg: 'An unexpected error occurred. Try again');
    }
  }
}
