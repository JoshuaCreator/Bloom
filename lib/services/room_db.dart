import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../views/dialogues/loading_indicator_build.dart';
import '../utils/imports.dart';

class RoomDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _roomRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future create(
    Room room,
    BuildContext context, {
    required String userId,
    required File? image,
  }) async {
    // _firestore.settings = const Settings(persistenceEnabled: false);
    _roomRef = _firestore.collection('rooms');

    try {
      showLoadingIndicator(context, label: 'Creating...');
      await _roomRef.add({
        'name': room.name,
        'desc': room.desc,
        'creatorId': room.creatorId,
        'private': room.private,
        'image': room.image,
        'createdAt': room.createdAt,
        'participants': room.participants,
      }).then(
        (value) {
          value.update({'id': value.id}).then(
            (_) {
              _roomRef
                  .doc(value.id)
                  .collection('participants')
                  .doc(userId)
                  .set({
                'id': userId,
                'joined': DateTime.now(),
              }).then((_) async {
                final path = 'rooms/${room.name}/${image?.path}';
                // try {
                if (image != null) {
                  final uploadTask =
                      await storageRef.ref().child(path).putFile(image);

                  final downloadUrl = await uploadTask.ref.getDownloadURL();

                  _roomRef.doc(value.id).update({'image': downloadUrl});
                }
                // } on FirebaseException catch (e) {
                // if (context.mounted) {
                //   showSnackBar(context, msg: 'An error occurred: $e');
                // }
                // }
              });
            },
          ).then((value) {
            context.go(HomeScreen.id);
            showSnackBar(context, msg: 'Your Room has been created');
          });
        },
      ).catchError((e) {
        context.pop();
        showSnackBar(context, msg: e);
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
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

  Future join(
    BuildContext context, {
    required String roomId,
    required String userId,
    required String roomName,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      showLoadingIndicator(context, label: 'Joining...');
      _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(userId)
          .set({
        // 'name': user?['name'],
        // 'lName': user?['lName'],
        'id': userId,
        // 'image': user?['image'],
        'joined': DateTime.now(),
      }).then((value) {
        _firestore.collection('rooms').doc(roomId).update({
          'participants': [userId],
        }).then((value) {
          context.pop();
          showSnackBar(
            context,
            msg: "You've joined $roomName",
          );
        }).catchError((e) {
          context.pop();
          showSnackBar(
            context,
            msg: "Unable to join $roomName. Try again",
          );
        }).timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            context.pop();
            showSnackBar(
              context,
              msg:
                  'The connection timed out. Check your internet connection and try again',
            );
          },
        );
      });
    } catch (e) {
      showSnackBar(
        context,
        msg: "An error occurred: $e",
      );
    }
  }

  Future leave(
    BuildContext context, {
    required String roomId,
    required String userId,
    required String roomName,
    void Function()? onComplete,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      showLoadingIndicator(context, label: 'Exiting...');
      _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(userId)
          .delete()
          .then((value) {
        _firestore.collection('rooms').doc(roomId).update({
          'participants': FieldValue.arrayRemove([userId]),
        }).then((value) {
          context.pop();
          context.pop();
          onComplete!();
          showSnackBar(
            context,
            msg: "You left $roomName",
          );
        }).catchError((e) {
          context.pop();
          context.pop();
          showSnackBar(
            context,
            msg: "Unable to exit $roomName. Try again",
          );
        }).timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            context.pop();
            showSnackBar(
              context,
              msg:
                  'The connection timed out. Check your internet connection and try again',
            );
          },
        );
      });
    } catch (e) {
      showSnackBar(
        context,
        msg: "An error occurred: $e",
      );
    }
  }

  Future delete(
    BuildContext context, {
    required String roomId,
    required String roomName,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      showLoadingIndicator(context, label: 'Deleting...');
      _firestore.collection('rooms').doc(roomId).delete().then((value) {
        context.pop();
        context.pop();
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: "$roomName deleted",
        );
      }).catchError((e) {
        context.pop();
        showSnackBar(
          context,
          msg: "Unable to delete $roomName",
        );
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          context.pop();
          showSnackBar(
            context,
            msg:
                'The connection timed out. Check your internet connection and try again',
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        msg: "An error occurred: $e",
      );
    }
  }
}
