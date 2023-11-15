import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

import '../../configs/consts.dart';

imagePickerDialogue(
  BuildContext context, {
  required void Function()? onStorageTapped,
  required void Function()? onCameraTapped,
}) {
  showModalBottomSheet(
    enableDrag: false,
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sd_storage_outlined),
            title: const Text('Device storage'),
            onTap: onStorageTapped,
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Camera'),
            onTap: onCameraTapped,
          ),
        ],
      );
    },
  );
}


//! Feature suspended due to feature being disabled in Firebase 
changeEmailBOttomSheet(
  BuildContext context, {
  required TextEditingController emailController,
  required void Function()? onSaved,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    enableDrag: false,
    context: context,
    builder: (context) {
      double bottom = MediaQuery.viewInsetsOf(context).bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(ten, ten, ten, bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Change your email')],
            ),
            height10,
            AppTextField(
              hintText: 'Enter you new email',
              borderless: true,
              controller: emailController,
              autofocus: true,
              onFieldSubmitted: (_) => onSaved,
            ),
            height30,
            AppButton(label: 'Save', onTap: onSaved),
            height10,
          ],
        ),
      );
    },
  );
}
