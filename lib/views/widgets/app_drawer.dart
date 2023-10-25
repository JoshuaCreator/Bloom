import 'package:basic_board/views/screens/create_room_screen.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:basic_board/views/screens/settings_screen.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
// import 'package:basic_board/views/widgets/room_tile.dart';
// import '../../models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../configs/consts.dart';
import '../screens/account_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.user,
    required this.room,
    this.auth,
  });
  final AsyncValue<Map<String, dynamic>?> user;
  final AsyncValue<List<QueryDocumentSnapshot<Map<String, dynamic>>>> room;
  final User? auth;
  @override
  Widget build(BuildContext context) {
    final email = auth?.email;
    // final uid = auth?.uid;
    bool visible = user.value?['admin'];
    return Drawer(
      child: Column(
        children: [
          ColoredBox(
            color: Colors.cyan,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  context.pop();
                  context.push(
                    '${HomeScreen.id}/${AccountScreen.id}',
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: thirty + five),
                    SizedBox(width: ten),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size * 5,
                          child: Text(
                            user.value?['fName'] + ' ' + user.value?['lName'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: size * 5,
                          child: Text(
                            email!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: room.when(
                //     data: (data) => ListView.builder(
                //       padding: EdgeInsets.only(top: twenty),
                //       itemCount: room.value?.length,
                //       itemBuilder: (context, index) {
                //         final Room roomData = Room(
                //           creatorName: room.value?[index]['creator_name'],
                //           creatorId: uid!,
                //           name: room.value?[index]['name'],
                //           private: room.value?[index]['private'],
                //         );
                //         bool visible = roomData.private && user.value?['admin'];
                //         return Visibility(
                //           visible: visible,
                //           child: RoomTile(selected: false, name: roomData.name),
                //         );
                //       },
                //     ),
                //     error: (error, stackTrace) => const Center(
                //       child: Text('An error occurred'),
                //     ),
                //     loading: () => const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.all(ten),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTextButtonIcon(
                        label: 'Settings',
                        icon: Icons.settings_rounded,
                        onPressed: () {
                          context.pop();
                          context.push(
                            '${HomeScreen.id}/${SettingsScreen.id}',
                          );
                        },
                      ),
                      Visibility(
                        visible: visible,
                        child: AppTextButtonIcon(
                          label: 'Create Room',
                          icon: Icons.add_rounded,
                          onPressed: () {
                            context.pop();
                            context.push(
                              '${HomeScreen.id}/${CreateRoomScreen.id}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
