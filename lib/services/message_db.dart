import 'package:basic_board/models/message.dart';
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

  Future send(
    Message message,
    BuildContext context, {
    required CollectionReference ref,
    required String? filePath,
    required String deptId,
    required String roomId,
  }) async {
    try {
      await ref.add({
        'message': message.message,
        'senderId': message.senderId,
        'image': message.image,
        'time': message.time
      }).then((value) async {
        String downloadUrl = '';
        value.update({'id': value.id});
        filePath == null
            ? null
            : downloadUrl = await imageHelper.uploadImage(
                context,
                imagePath: filePath,
                docRef: _firestore
                    .collection('departments')
                    .doc(deptId)
                    .collection('rooms')
                    .doc(roomId)
                    .collection('messages')
                    .doc(value.id),
                storagePath:
                    'departments/$deptId/rooms/$roomId/messages/${value.id}.png',
                msg: 'File uploaded and sent',
              );
        value.update({'image': downloadUrl});
      }).catchError((e) {
        context.pop();
        showSnackBar(
          context,
          msg: e,
        );
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
        showSnackBar(
          context,
          msg: e,
        );
      });
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future edit(
    BuildContext context, {
    required String roomId,
    required String deptId,
    required String messageId,
    required String newMessage,
  }) async {
    try {
      _firestore
          .collection('departments')
          .doc(deptId)
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'message': newMessage,
      }).then((value) {
        context.pop();
        showSnackBar(
          context,
          msg: 'Message edited',
        );
      }).catchError((e) {
        context.pop();
        showSnackBar(
          context,
          msg: 'Oops! Unable to message.',
        );
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          showSnackBar(
            context,
            msg: 'Your connection timed out',
          );
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
        },
      );
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
