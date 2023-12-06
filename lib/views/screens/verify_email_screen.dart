import 'dart:async';

import 'package:basic_board/views/screens/room/room_chats_screen.dart';
import 'package:basic_board/views/screens/space/space_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/services/auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  static String id = '/verify-email';
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final auth = FirebaseAuth.instance;
  late Timer timer;
  @override
  void initState() {
    if (!auth.currentUser!.emailVerified) {
      Auth().sendEmailVerificationLink(context);
    }
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        setState(() {
          auth.currentUser?.reload();
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A verification email has been sent to you at ${auth.currentUser?.email}',
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: auth.currentUser!.emailVerified,
            child: Column(
              children: [
                height30,
                TextButton(
                  child: const Text('Verified'),
                  onPressed: () {
                    if (auth.currentUser!.emailVerified) {
                      context.go('${SpaceScreen.id}/${RoomChatsScreen.id}');
                    } else {
                      return;
                    }
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: !auth.currentUser!.emailVerified,
            child: Column(
              children: [
                height30,
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Auth().signOut(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
