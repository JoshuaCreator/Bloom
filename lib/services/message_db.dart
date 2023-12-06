import 'package:basic_board/models/message.dart';
import 'package:basic_board/services/file_helper.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/reply.dart';
import '../views/dialogues/loading_indicator_build.dart';
import '../views/dialogues/snack_bar.dart';

class MessageDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _messageRef;
  final ImageHelper imageHelper = ImageHelper();
  final FileHelper fileHelper = FileHelper();

  Future send(
    Message message,
    BuildContext context, {
    required CollectionReference ref,
    required String wrkspcId,
    required String roomId,
  }) async {
    try {
      await ref.add({
        'message': message.message,
        'senderId': message.senderId,
        'image': message.image,
        'file': message.file,
        'time': message.time,
        'likes': [],
      }).then((doc) async {
        final docRef = _firestore
            .collection('workspaces')
            .doc(wrkspcId)
            .collection('rooms')
            .doc(roomId)
            .collection('messages')
            .doc(doc.id);
        doc.update({'id': doc.id});
        message.image == null
            ? message.file != null
                ? await fileHelper.uploadFile(
                    context,
                    filePath: message.file!,
                    docRef: docRef,
                    storagePath:
                        'workspaces/$wrkspcId/rooms/$roomId/messages/${doc.id + DateTime.now().toString() + message.file!}',
                  )
                : null
            : await imageHelper.uploadImage(
                context,
                imagePath: message.image!,
                docRef: docRef,
                storagePath:
                    'workspaces/$wrkspcId/rooms/$roomId/messages/${doc.id + DateTime.now().toString()}.png',
                msg: 'File uploaded and sent',
              );
      }).catchError((e) {
        context.pop();
        showSnackBar(context, msg: '$e');
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future reply(
    Reply reply,
    BuildContext context, {
    required CollectionReference ref,
  }) async {
    try {
      await ref.add({
        'reply': reply.message,
        'replySenderId': reply.replySenderId,
        'toMessageId': reply.toMessageId,
        'toSenderId': reply.toSenderId,
        'time': reply.time,
        'likes': [],
      }).then(
        (value) {
          value.update({'id': value.id});
        },
      ).catchError((e) {
        context.pop();
        showSnackBar(context, msg: e);
      });
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future edit(
    BuildContext context, {
    required String roomId,
    required String spaceId,
    required String messageId,
    required String newMessage,
  }) async {
    showLoadingIndicator(context, label: 'Updating...');
    try {
      _firestore
          .collection('workspaces')
          .doc(spaceId)
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'message': newMessage,
      }).then((value) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Message edited',
        );
      }).catchError((e) {
        context.pop();
        showSnackBar(context, msg: 'Oops! Unable to message.');
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          showSnackBar(context, msg: 'Your connection timed out');
          return;
        },
      );
    } catch (e) {
      showSnackBar(context, msg: 'An error occurred: $e');
    }
  }

  Future delete(String id, BuildContext context) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    _messageRef = _firestore.collection('anouncements');

    try {
      showLoadingIndicator(context, label: 'Deleting...');
      await _messageRef.doc(id).delete().then(
        (value) {
          context.pop();
          showSnackBar(
            context,
            msg: 'Message deleted',
          );
        },
      ).catchError((e) {
        context.pop();
        showSnackBar(
          context,
          msg: e,
        );
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          context.pop();
          context.pop();
          showSnackBar(
            context,
            msg:
                'The connection timed out. Check your internet connection and try again',
          );
          return;
        },
      );
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
