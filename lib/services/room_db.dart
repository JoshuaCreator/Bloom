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
        'creator': room.creator,
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

  // Future<bool> addParticipants(BuildContext context, {required Room room}) {
  //   try {
  //     showLoadingIndicator(context);
  //     _firestore
  //         .collection('rooms')
  //         .doc(room.id)
  //         .collection('participants')
  //         .doc(auth.uid)
  //         .set({
  //       'fName': user?['fName'],
  //       'lName': user?['lName'],
  //       'id': user?['id'],
  //       'joined': DateTime.now(),
  //     }).then((value) {
  //       _firestore.collection('rooms').doc(roomData.id).update({
  //         'participants': [auth.uid],
  //       }).then((value) {
  //         context.pop();
  //         showSnackBar(
  //           context,
  //           msg: "You've joined ${roomData.name}",
  //         );
  //       });
  //     });
  //   } catch (e) {}
  // }

  // Future<bool> delete(String id, BuildContext context) async {
  //   _roomRef = _firestore.collection('anouncements');

  //   try {
  //     showLoadingIndicator(context);
  //     await _roomRef.doc(id).delete().then(
  //       (value) {
  //         context.pop();
  //         showSnackBar(
  //           context,
  //           msg: 'Message deleted',
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
  //           msg:
  //               'The connection timed out. Check your internet connection and try again',
  //         );
  //       },
  //     );
  //     return true;
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }
}
