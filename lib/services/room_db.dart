import 'package:basic_board/models/room.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/dialogues/loading_indicator_build.dart';
import '../views/dialogues/snack_bar.dart';

class RoomDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _roomRef;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> create(Room room, BuildContext context, {required user}) async {
    _roomRef = _firestore.collection('rooms');

    try {
      showLoadingIndicator(context);
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
            (room) => _roomRef
                .doc(value.id)
                .collection('participants')
                .doc(user['id'])
                .set({
              'fName': user['fName'],
              'lName': user['lName'],
              'id': user['id'],
              'joined': DateTime.now(),
            }).then((value) {
              context.go(HomeScreen.id);
              showSnackBar(context, msg: 'Your Room has been created');
            }),
          );
        },
      ).catchError((e) {
        context.pop();
        showSnackBar(context, msg: e);
      }).timeout(
        const Duration(seconds: 10),
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
    try {
      showLoadingIndicator(context);
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
        });
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
    try {
      showLoadingIndicator(context);
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
        });
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
    try {
      showLoadingIndicator(context);
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
      });
    } catch (e) {
      showSnackBar(
        context,
        msg: "An error occurred: $e",
      );
    }
  }
}
