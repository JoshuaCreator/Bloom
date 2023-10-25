import 'package:basic_board/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/widgets/loading_indicator.dart';
import '../views/widgets/snack_bar.dart';

class MessageDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _messageRef;

  Future<bool> send(
    Message notice,
    BuildContext context, {
    required CollectionReference ref,
  }) async {
    // _messageRef = ref;
    // _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      await ref.add({
        'message': notice.message,
        'sender': notice.sender,
        'image': notice.image,
        'time': notice.time
      }).then(
        (value) {
          value.update({'id': value.id});
          // context.pop();
          // showSnackBar(
          //   context,
          //   msg: '',
          // );
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

  // Future<bool> edit(BuildContext context,
  //     {required NoteModel note, required String id}) async {
  //   _noteRef = _firestore
  //       .collection('users')
  //       .doc(_firebaseAuth.currentUser?.uid)
  //       .collection('study_notes');

  //   try {
  //     showLoadingIndicator(context);
  //     await _noteRef.doc(id).update({
  //       'title': note.title,
  //       'note': note.content,
  //       'createdAt': DateTime.now(),
  //     }).then(
  //       (value) {
  //         context.pop();
  //         context.pop();
  //         showSnackBar(
  //           context,
  //           msg: 'Note updated',
  //         );
  //       },
  //     ).catchError((e) {
  //       context.pop();
  //       showSnackBar(
  //         context,
  //         msg: e,
  //       );
  //     }).timeout(
  //       const Duration(seconds: 10),
  //       onTimeout: () {
  //         context.pop();
  //         context.pop();
  //         showSnackBar(
  //           context,
  //           msg: 'The connection timed out. Check your internet connection',
  //         );
  //       },
  //     );
  //     return true;
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  Future<bool> delete(String id, BuildContext context) async {
    _messageRef = _firestore.collection('anouncements');

    try {
      showLoadingIndicator(context);
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
