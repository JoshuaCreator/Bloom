import 'package:basic_board/views/screens/room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../configs/consts.dart';
import '../../models/room.dart';
import '../../providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/room_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String id = '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool roomsVisible = true;
  bool chatsVisible = true;
  double roomsTurns = 0.0;
  double chatsTurns = 0.0;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final room = ref.watch(roomProvider);
    final auth = ref.watch(authStateProvider).value;

    return Scaffold(
      drawer: AppDrawer(room: room, user: user, auth: auth),
      appBar: AppBar(title: const Text('Home')),
      body: room.when(
        data: (data) => Column(
          children: [
            height10,
            const SearchTile(),
            height20,
            SectionDivider(
              title: 'Rooms',
              turns: roomsTurns,
              onTap: () => setState(() {
                roomsVisible ? roomsVisible = false : roomsVisible = true;
                roomsVisible
                    ? roomsTurns -= 1.0 / 2.0
                    : roomsTurns += 1.0 / 2.0;
              }),
            ),
            Flexible(
              child: AnimatedSize(
                alignment: Alignment.bottomCenter,
                curve: Curves.ease,
                duration: Duration(milliseconds: animationDuration),
                reverseDuration: Duration(milliseconds: animationDuration),
                child: Visibility(
                  visible: roomsVisible,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: ten, left: ten, right: ten),
                    itemCount: room.value?.length,
                    itemBuilder: (context, index) {
                      final Room roomData = Room(
                        id: room.value?[index]['id'],
                        creator: room.value?[index]['creator'],
                        creatorId: auth!.uid,
                        name: room.value?[index]['name'],
                        private: room.value?[index]['private'],
                      );

                      // bool visible = roomData.private || user.value?['admin'];

                      bool showRoom() {
                        if (user.value?['admin'] && roomData.private) {
                          return true;
                        } else if (user.value?['admin'] && !roomData.private) {
                          return true;
                        } else if (!user.value?['admin'] && !roomData.private) {
                          return true;
                        } else {
                          return false;
                        }
                      }

                      bool visible = showRoom();
                      return Visibility(
                        visible: visible,
                        child: RoomTile(
                          leading: Icons.people_rounded,
                          selected: false,
                          name: roomData.name,
                          onTap: () {
                            context.push(
                              '${HomeScreen.id}/${RoomScreen.id}',
                              extra: roomData,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            height20,
            // SectionDivider(
            //   title: 'Chats',
            //   turns: chatsTurns,
            //   onTap: () => setState(() {
            //     chatsVisible ? chatsVisible = false : chatsVisible = true;
            //     chatsVisible
            //         ? chatsTurns -= 1.0 / 2.0
            //         : chatsTurns += 1.0 / 2.0;
            //   }),
            // ),
            // Flexible(
            //   child: AnimatedSize(
            //     alignment: Alignment.bottomCenter,
            //     curve: Curves.ease,
            //     duration: Duration(milliseconds: animationDuration),
            //     reverseDuration: Duration(milliseconds: animationDuration),
            //     child: Visibility(
            //       visible: chatsVisible,
            //       child: ListView.builder(
            //         padding: EdgeInsets.only(top: ten, left: ten, right: ten),
            //         itemCount: room.value?.length,
            //         itemBuilder: (context, index) {
            //           final Room roomData = Room(
            //             creator: room.value?[index]['creator'],
            //             creatorId: auth!.uid,
            //             name: room.value?[index]['name'],
            //             private: room.value?[index]['private'],
            //             // participants: room.value?[index]['participants'], // Get Participants
            //             // messages: messages.value,
            //           );

            //           // bool visible = roomData.private || user.value?['admin'];

            //           bool showRoom() {
            //             if (user.value?['admin'] && roomData.private) {
            //               return true;
            //             } else if (user.value?['admin'] && !roomData.private) {
            //               return true;
            //             } else if (!user.value?['admin'] && !roomData.private) {
            //               return true;
            //             } else {
            //               return false;
            //             }
            //           }

            //           bool visible = showRoom();
            //           return Visibility(
            //             visible: visible,
            //             child: RoomTile(
            //               leading: Icons.people_rounded,
            //               selected: false,
            //               name: roomData.name,
            //               onTap: () {
            //                 context.push(
            //                   '${HomeScreen.id}/${RoomScreen.id}',
            //                   extra: roomData,
            //                 );
            //               },
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ten),
      child: InkWell(
        onTap: () {
          // TODO Show Search Delegate
        },
        borderRadius: BorderRadius.circular(ten),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: twenty,
            vertical: ten,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(ten),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded),
              SizedBox(width: ten),
              const Text('search...', style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider(
      {super.key, this.onTap, required this.turns, required this.title});
  final void Function()? onTap;
  final double turns;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(ten),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedRotation(
              turns: turns,
              duration: Duration(milliseconds: animationDuration),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
