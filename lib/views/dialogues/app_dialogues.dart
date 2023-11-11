import 'package:basic_board/views/dialogues/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/consts.dart';
import '../../services/room_db.dart';
import '../widgets/app_text_buttons.dart';
import 'loading_indicator_build.dart';

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

deleteAlertDialogue(BuildContext context,
    {required String msgId, required msgRef}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text('Delete message?\nThis can not be reversed'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
        ),
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppTextButton(
            label: 'Proceed',
            onPressed: () {
              showLoadingIndicator(context);
              msgRef.doc(msgId).delete().then((value) {
                context.pop();
                context.pop();
                context.pop();
                showSnackBar(context, msg: 'Message deleted');
              }).catchError((e) {
                context.pop();
                context.pop();
                showSnackBar(context, msg: 'Unable to delete message');
              });
            },
          ),
          AppTextButton(
            label: 'Cancel',
            onPressed: () => context.pop(),
          ),
        ],
      );
    },
  );
}

leaveRoomDialogue(
  BuildContext context, {
  required String roomName,
  required String userId,
  required String roomId,
  void Function()? onComplete,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text('Leave $roomName?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
        ),
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppTextButton(
            label: 'Leave',
            onPressed: () {
              //? Leave Room
              RoomDB().leave(
                context,
                roomId: roomId,
                userId: userId,
                roomName: roomName,
                onComplete: onComplete,
              );
            },
          ),
          AppTextButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}

deleteRoomDialogue(
  BuildContext context, {
  required String roomId,
  required String roomName,
  void Function()? onComplete,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          'You are about to delete $roomName.\nAll participants will be removed and all messages will be deleted.\nThis cannot be undone.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
        ),
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppTextButton(
            label: 'Delete',
            onPressed: () {
              //? Delete Room
              RoomDB().delete(
                context,
                roomId: roomId,
                roomName: roomName,
              );
            },
          ),
          AppTextButton(
            label: 'Cancel',
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}
