import 'package:basic_board/views/dialogues/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/consts.dart';

linkAlertDialogue(
  BuildContext context, {
  required Uri link,
  required String linkString,
}) {
  return showDialog(
    context: context,
    builder: (context) => SizedBox(
      width: double.infinity,
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        // title: const Text('Open link'),
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
        ),
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.all(ten),
        content: Text.rich(
          TextSpan(
            text: 'Do you want to open ',
            children: [
              TextSpan(
                text: '$link',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: linkString))
                .then((value) {
              context.pop();
              showSnackBar(context, msg: 'Copied to clipboard');
            }),
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              await launchUrl(link, mode: LaunchMode.inAppWebView).catchError(
                (value) =>
                    showSnackBar(context, msg: 'Unable to open this link'),
              );
            },
            child: const Text('Open'),
          ),
        ],
      ),
    ),
  );
}