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
    required String deptId,
    required File? image,
  }) async {
    _roomRef =
        _firestore.collection('departments').doc(deptId).collection('rooms');

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
              _firestore.collection('departments').doc(deptId).update({
                'rooms': FieldValue.arrayUnion([value.id])
              });
              _roomRef.doc(value.id).update({
                'rooms': FieldValue.arrayUnion([value.id])
              });
              _roomRef
                  .doc(value.id)
                  .collection('participants')
                  .doc(userId)
                  .set({
                'id': userId,
                'joined': DateTime.now(),
              }).then((_) async {
                final path = 'rooms/${room.name}/${image?.path}';
                await _roomRef.doc(value.id).update({
                  'image': await uploadImageGetUrl(
                    context,
                    path: path,
                    image: image,
                  ),
                });
              });
            },
          ).then((value) {
            context.pop();
            context.pop();
            showSnackBar(context, msg: '${room.name} has been created');
          });
        },
      ).catchError((e) {
        context.pop();
        showSnackBar(context, msg: 'An error occurred: $e');
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          context.pop();
          showSnackBar(
            context,
            msg: 'The connection timed out',
          );
        },
      );
      return true;
    } catch (e) {
      return Future.error('An error occurred: $e');
    }
  }

  Future<String> uploadImageGetUrl(
    BuildContext context, {
    File? image,
    required String path,
  }) async {
    if (image == null) return '';
    final uploadTask = storageRef.ref().child(path).putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future join(
    BuildContext context, {
    required String deptId,
    required String roomId,
    required String userId,
    required String roomName,
  }) async {
    try {
      showLoadingIndicator(context, label: 'Joining...');
      _firestore
          .collection('departments')
          .doc(deptId)
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(userId)
          .set({
        'id': userId,
        'joined': DateTime.now(),
      }).then((value) {
        _firestore
            .collection('departments')
            .doc(deptId)
            .collection('rooms')
            .doc(roomId)
            .update({
          'participants': FieldValue.arrayUnion([userId]),
        }).then((value) {
          context.pop();
          showSnackBar(context, msg: "You've joined $roomName");
        }).catchError((e) {
          context.pop();
          showSnackBar(context, msg: "Unable to join $roomName. Try again");
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
    required String deptId,
    required String userId,
    required String roomName,
  }) async {
    try {
      showLoadingIndicator(context, label: 'Exiting...');
      _firestore
          .collection('departments')
          .doc(deptId)
          .collection('rooms')
          .doc(roomId)
          .collection('participants')
          .doc(userId)
          .delete()
          .then((value) {
        _firestore
            .collection('departments')
            .doc(deptId)
            .collection('rooms')
            .doc(roomId)
            .update({
          'participants': FieldValue.arrayRemove([userId])
        }).then((value) {
          context.pop();
          context.pop();
          showSnackBar(context, msg: "You left $roomName");
        }).catchError((e) {
          context.pop();
          showSnackBar(context, msg: "Unable to exit $roomName. Try again");
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
      showSnackBar(context, msg: "An error occurred: $e");
    }
  }

  Future edit(
    BuildContext context, {
    required String deptId,
    required String roomId,
    String? name,
    String? desc,
  }) async {
    try {
      showLoadingIndicator(context);
      _firestore
          .collection('departments')
          .doc(deptId)
          .collection('rooms')
          .doc(roomId)
          .update({'name': name, 'desc': desc}).then((value) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Room info updated successfully',
        );
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Oops! Unable to update Room info. \n Try again',
        );
      });
    } catch (e) {
      showSnackBar(context, msg: "An error occurred: $e");
    }
  }

  Future delete(
    BuildContext context, {
    required String roomId,
    required String roomName,
    required String deptId,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      showLoadingIndicator(context, label: 'Deleting...');
      _firestore
          .collection('departments')
          .doc(deptId)
          .collection('rooms')
          .doc(roomId)
          .delete()
          .then((value) {
        _firestore.collection('departments').doc(deptId).update({
          'rooms': FieldValue.arrayRemove([roomId])
        });
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
