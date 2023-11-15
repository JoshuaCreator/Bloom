// import 'package:basic_board/views/screens/create_room_screen.dart';
// import 'package:basic_board/views/screens/home_screen.dart';
// import 'package:basic_board/views/screens/settings_screen.dart';
// import 'package:basic_board/views/widgets/app_text_buttons.dart';
// import 'package:basic_board/views/widgets/room_tile.dart';
// import '../../models/room.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/create_dept_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../configs/consts.dart';
// import '../screens/account_screen.dart';
import '../../configs/consts.dart';
import '../../models/room.dart';
import 'profile_tile.dart';
import 'room_tile.dart';

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
    // final uid = auth?.uid;
    // bool visible = user.value?['admin'];
    return Drawer(
      child: Column(
        children: [
          // ColoredBox(
          //   color: Colors.cyan,
          //   child: DrawerHeader(
          //     margin: EdgeInsets.zero,
          //     child: ProfileTile(user: user, email: email),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: size + ten, left: ten, right: ten),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Departments',
                  style: TextStyle(fontSize: twenty + five),
                ),
                AppTextButton(
                  label: 'Create',
                  onPressed: () {
                    context.pop();
                    context.push('${HomeScreen.id}/${CreateDeptScreen.id}');
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: room.when(
                    data: (data) => ListView.builder(
                      padding: EdgeInsets.only(top: ten),
                      itemCount: room.value?.length,
                      itemBuilder: (context, index) {
                        final Room roomData = Room(
                          creatorId: room.value?[index]['creatorId'],
                          name: room.value?[index]['name'],
                          private: room.value?[index]['private'],
                          participants: room.value?[index]['participants'],
                          createdAt: (room.value?[index]['createdAt']).toDate(),
                          id: room.value?[index].id,
                          image: room.value?[index]['image'],
                        );
                        // bool visible = roomData.private;
                        // return Visibility(
                        //   visible: true,
                        //   child: RoomTile(
                        //     name: roomData.name,
                        //     subtitle: '',
                        //     image: roomData.image ?? '',
                        //   ),
                        // );
                        return DepartmentTile(
                          id: roomData.id!,
                          title: roomData.name,
                          subtitle: 'Created ${roomData.createdAt}',
                          onTap: () {
                            // context.pop();
                            context.go(AllRoomsScreen.id);
                          },
                        );
                      },
                    ),
                    error: (error, stackTrace) => const Center(
                      child: Text('An error occurred'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.all(ten),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       AppTextButtonIcon(
                //         label: 'Settings',
                //         icon: Icons.settings_rounded,
                //         onPressed: () {
                //           context.pop();
                //           context.push(
                //             '${HomeScreen.id}/${SettingsScreen.id}',
                //           );
                //         },
                //       ),
                //       Visibility(
                //         visible: visible,
                //         child: AppTextButtonIcon(
                //           label: 'Create Room',
                //           icon: Icons.add_rounded,
                //           onPressed: () {
                //             context.pop();
                //             context.push(
                //               '${HomeScreen.id}/${CreateRoomScreen.id}',
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DepartmentTile extends StatelessWidget {
  const DepartmentTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final String id, title, subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: twenty, vertical: ten),
        margin: EdgeInsets.symmetric(horizontal: ten, vertical: five),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: defaultBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: twenty - 2, color: Colors.white),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
