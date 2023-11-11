import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../configs/consts.dart';
import '../widgets/app_text_field.dart';

infoEditDialogue(
  BuildContext context, {
  required void Function()? onSaved,
  bool showName = true,
  bool showAbout = true,
  bool isRoom = false,
  TextEditingController? nameController,
  TextEditingController? aboutController,
  final String? title,
}) {
  String defaultTitle = '';
  String name = '';
  String about = '';
  text() {
    if (showName && isRoom) {
      defaultTitle = 'Edit Room info';
      name = 'Room name';
      about = 'Room description';
    } else if (!showName && isRoom) {
      defaultTitle = 'Room description';
      name = 'Room name';
      about = 'Room description';
    } else {
      defaultTitle = 'Edit name and about';
      name = 'Name';
      about = 'About';
    }
  }

  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: false,
    context: context,
    builder: (context) {
      text();
      double bottom = MediaQuery.viewInsetsOf(context).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(ten, ten, ten, bottom),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(
                  title ?? defaultTitle,
                  style: TextConfig.intro,
                ),
              ]),
              height10,
              Visibility(
                visible: showName,
                child: Column(
                  children: [
                    AppTextField(
                      hintText: name,
                      borderless: true,
                      textInputAction: showAbout
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autofocus: true,
                      controller: nameController,
                      onFieldSubmitted: (_) => onSaved!(),
                    ),
                    height10,
                  ],
                ),
              ),
              Visibility(
                visible: showAbout,
                child: AppTextField(
                  hintText: about,
                  borderless: true,
                  maxLines: 2,
                  autofocus: true,
                  controller: aboutController,
                  onFieldSubmitted: (_) => onSaved!(),
                ),
              ),
              height30,
              AppButton(label: 'Save', onTap: onSaved),
              height10,
            ],
          ),
        ),
      );
    },
  );
}
