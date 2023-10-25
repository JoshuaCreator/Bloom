import 'package:basic_board/models/room.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/widgets/loading_indicator.dart';
import '../views/widgets/snack_bar.dart';

class RoomDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _roomRef;

  Future<bool> create(Room room, BuildContext context) async {
    _roomRef = _firestore.collection('rooms');

    try {
      showLoadingIndicator(context);
      // _roomRef.where('name', isEqualTo: room.name).get().then(
      //   (value) {
      //     context.go(HomeScreen.id);
      //     showSnackBar(context, msg: 'This Room already exists');
      //     return;
      //   },
      // );
      await _roomRef.add({
        'name': room.name,
        'desc': room.desc,
        'creator': room.creator,
        'creatorId': room.creatorId,
        'private': room.private,
        'image': room.image,
        'createdAt': room.createdAt,
      }).then(
        (value) {
          value.update({'id': value.id});
          context.go(HomeScreen.id);
          showSnackBar(context, msg: 'Your Room has been created');
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
