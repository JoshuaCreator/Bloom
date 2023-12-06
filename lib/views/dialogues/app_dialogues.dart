import 'package:basic_board/services/auth.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/workspace_db.dart';
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

deleteMessageAlertDialogue(BuildContext context,
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
  required String wrkspcId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Leave this Room?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actions: [
          AppButton(
            label: 'Cancel',
            onTap: () {
              context.pop();
            },
          ),
          AppTextButton(
            label: 'Leave',
            onPressed: () {
              RoomDB().leave(
                context,
                spaceId: wrkspcId,
                roomId: roomId,
                userId: userId,
                roomName: roomName,
              );
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
  required String wrkspcId,
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
                wrkspcId: wrkspcId,
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

deleteAccountDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text(
          'You are about to delete your account. This cannot be reversed and your data will be lost forever.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppTextButton(
            label: 'Delete',
            onPressed: () {
              Auth().deleteAccount(context);
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

// The "deleteSpaceDialogue" is not currently in use
deleteSpaceDialogue(
  BuildContext context, {
  required String wrkspcName,
  required String wrkspcId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          'You are about to delete $wrkspcName. All Rooms will be deleted and participants removed. This cannot be reversed.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppTextButton(
            label: 'Delete',
            onPressed: () {
              SpaceDB().delete(
                context,
                wrkspcName: wrkspcName,
                wrkspcId: wrkspcId,
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

leaveSpaceDialogue(
  BuildContext context, {
  required Space space,
  required String spaceName,
  required String userId,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Leave $spaceName?',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        insetPadding: EdgeInsets.all(ten),
        actions: [
          AppButton(
            label: 'Cancel',
            onTap: () {
              context.pop();
            },
          ),
          AppTextButton(
            label: 'Leave',
            onPressed: () {
              SpaceDB()
                  .exit(context, space: space, userId: userId)
                  .then((value) => context.go(SpaceScreen.id));
            },
          ),
        ],
      );
    },
  );
}
