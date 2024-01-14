import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';

class AddCourseDialogue extends StatelessWidget {
  const AddCourseDialogue({
    super.key,
    required this.titleController,
    required this.codeController,
    required this.descController,
    required this.lecturerController,
    this.onAdd,
  });
  final TextEditingController titleController,
      codeController,
      descController,
      lecturerController;
  final void Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.viewInsetsOf(context).bottom;
    bool showButton = titleController.text.trim().isNotEmpty &&
        codeController.text.trim().isNotEmpty;
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, bottom + 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add course', style: TextStyle(fontSize: 22.0)),
          const Gap(20.0),
          AppTextField(
            hintText: 'Title (required)',
            borderless: true,
            textInputAction: TextInputAction.next,
            autofocus: true,
            controller: titleController,
          ),
          const Gap(10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: AppTextField(
                  hintText: 'Code (required)',
                  borderless: true,
                  textInputAction: TextInputAction.next,
                  controller: codeController,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const Gap(10.0),
          AppTextField(
            hintText: 'Description',
            borderless: true,
            textInputAction: TextInputAction.next,
            maxLines: 3,
            controller: descController,
          ),
          const Gap(10.0),
          AppTextField(
            hintText: 'Lecturer',
            borderless: true,
            controller: lecturerController,
          ),
          const Gap(10.0),
          Visibility(
            visible: showButton,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(30.0),
                AppButton(label: 'Add', onTap: onAdd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
