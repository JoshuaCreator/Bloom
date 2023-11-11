import 'package:basic_board/configs/colour_config.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/dialogues/loading_indicator.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/screens/room_info_screen.dart';
import 'package:basic_board/views/widgets/room_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/room.dart';
import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../dialogues/snack_bar.dart';
import '../widgets/app_text_buttons.dart';
import 'home_screen.dart';
import 'room_chat_screen.dart';

class AllRoomsScreen extends ConsumerWidget {
  static String id = 'all-rooms';
  const AllRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider);
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value;
    final user = ref.watch(userProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Rooms'),
        actions: [
          IconButton(
            onPressed: () {
              //! TODO Show SearchDelegate
            },
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: room.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(twenty, twenty, ten, forty),
                  child: Text(
                    'Here are all public Rooms\nyou can join',
                    style: TextStyle(fontSize: twenty + five),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    DateTime timeStamp =
                        (room.value?[index]['createdAt']) == null
                            ? DateTime.now()
                            : (room.value?[index]['createdAt']).toDate();
                    final Room roomData = Room(
                      id: room.value![index]['id'],
                      creator: room.value?[index]['creator'],
                      creatorId: auth!.uid,
                      name: room.value?[index]['name'],
                      desc: room.value?[index]['desc'],
                      private: room.value?[index]['private'],
                      image: room.value?[index]['image'] ??
                          'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
                      createdAt: timeStamp,
                      participants: room.value?[index]['participants'],
                    );
                    String numberOfParticipants() {
                      if (roomData.participants.isEmpty) {
                        return '0 participants';
                      } else if (roomData.participants.length == 1) {
                        return '1 participant';
                      } else {
                        return '${roomData.participants.length} participants';
                      }
                    }

                    return RoomTile(
                      image: roomData.image!,
                      name: roomData.name,
                      subtitle: numberOfParticipants(),
                      trailing: AppTextButton(
                        label: roomData.participants.contains(auth.uid)
                            ? 'Leave'
                            : 'Join',
                        colour: roomData.participants.contains(auth.uid)
                            ? ColourConfig.danger
                            : ColourConfig.go,
                        onPressed: roomData.participants.contains(auth.uid)
                            ? () {
                                //? Leave Room
                                showLoadingIndicator(context);
                                firestore
                                    .collection('rooms')
                                    .doc(roomData.id)
                                    .collection('participants')
                                    .doc(auth.uid)
                                    .delete()
                                    .then((value) {
                                  firestore
                                      .collection('rooms')
                                      .doc(roomData.id)
                                      .update({
                                    'participants':
                                        FieldValue.arrayRemove([auth.uid]),
                                  }).then((value) {
                                    context.pop();
                                    showSnackBar(
                                      context,
                                      msg: "You left ${roomData.name}",
                                    );
                                  }).catchError((e) {
                                    context.pop();
                                    showSnackBar(
                                      context,
                                      msg:
                                          "Unable to exit ${roomData.name}. Try again",
                                    );
                                  });
                                });
                              }
                            : () {
                                //? Join Room
                                showLoadingIndicator(context);
                                firestore
                                    .collection('rooms')
                                    .doc(roomData.id)
                                    .collection('participants')
                                    .doc(auth.uid)
                                    .set({
                                  // 'name': user?['name'],
                                  // 'lName': user?['lName'],
                                  'id': user?['id'],
                                  // 'image': user?['image'],
                                  'joined': DateTime.now(),
                                }).then((value) {
                                  firestore
                                      .collection('rooms')
                                      .doc(roomData.id)
                                      .update({
                                    'participants': [auth.uid],
                                  }).then((value) {
                                    context.pop();
                                    showSnackBar(
                                      context,
                                      msg: "You've joined ${roomData.name}",
                                    );
                                  }).catchError((e) {
                                    context.pop();
                                    showSnackBar(
                                      context,
                                      msg:
                                          "Unable to join ${roomData.name}. Try again",
                                    );
                                  });
                                });
                              },
                      ),
                      onTap: () => context.push(
                        '${HomeScreen.id}/${RoomChatScreen.id}/${RoomInfoScreen.id}',
                        extra: roomData,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) =>
            const Center(child: Text('Oops! An error occurred')),
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}
