import 'package:basic_board/models/direct_message.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This File is currently not in use. Until further notice
///
///
///
///

class DirectChatDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _chatRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImageHelper imageHelper = ImageHelper();

  Future send(BuildContext context, DirectMsg msg,
      {required String recipientId, required String spaceId}) async {
    _chatRef = _firestore
        .collection('spaces')
        .doc(spaceId)
        .collection('chats')
        .doc('chat${msg.toId}')
        .collection('messages');
    try {
      await _chatRef.add({
        'fromId': msg.fromId,
        'toId': msg.toId,
        'message': msg.message,
        'image': msg.image,
        'file': msg.file,
        'time': msg.time,
      }).then((doc) async {
        _firestore
            .collection('spaces')
            .doc(spaceId)
            .collection('chats')
            .doc('chat${msg.toId}')
            .set({
          'participants': [auth.currentUser?.uid, recipientId],
        });
        msg.image == null
            ? null
            : await imageHelper.uploadImage(
                context,
                imagePath: msg.image!,
                docRef: _chatRef.doc('chat${msg.toId}'),
                storagePath: 'chats/chat${msg.toId}/files/${msg.message}.png',
              );
      });
    } catch (e) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: '$e');
      }
    }
  }
}
