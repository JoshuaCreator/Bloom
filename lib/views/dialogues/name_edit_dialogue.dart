import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:flutter/material.dart';

import '../../configs/consts.dart';
import '../widgets/app_text_field.dart';

nameEditDialogue(
  BuildContext context, {
  required void Function()? onSaved,
  bool showNameField = true,
  bool isRoom = false,
}) {
  String title = '';
  String name = '';
  String about = '';
  text() {
    if (showNameField && isRoom) {
      title = 'Edit Room info';
      name = 'Room name';
      about = 'Room description';
    } else if (!showNameField && isRoom) {
      title = 'Room description';
      name = 'Room name';
      about = 'Room description';
    } else {
      title = 'Edit name and about';
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
                  title,
                  style: TextConfig.intro,
                ),
              ]),
              height10,
              Visibility(
                visible: showNameField,
                child: Column(
                  children: [
                    AppTextField(
                      hintText: name,
                      borderless: true,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                    ),
                    height10,
                  ],
                ),
              ),
              AppTextField(
                hintText: about,
                borderless: true,
                maxLines: 2,
              ),
              height30,
              AppButton(title: 'Save', onTap: onSaved),
              height10,
            ],
          ),
        ),
      );
    },
  );
}
