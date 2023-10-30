import 'package:basic_board/views/screens/room_screen.dart';
import 'package:basic_board/views/dialogues/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../configs/consts.dart';
import '../../models/room.dart';
import '../../providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import '../widgets/room_tile.dart';
import 'create_room_screen.dart';
import 'settings_screen.dart';

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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final room = ref.watch(roomProvider);
    final auth = ref.watch(authStateProvider).value;
    final firestore = ref.watch(firestoreProvider);

    return Scaffold(
      // drawer: AppDrawer(room: room, user: user, auth: auth),
      appBar: AppBar(
        title: const Text("Joshua's chat app"),
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            offset: const Offset(0, kToolbarHeight),
            itemBuilder: (context) => [
              buildPopupMenuItem(
                context,
                onTap: () => context.push(
                  '${HomeScreen.id}/${CreateRoomScreen.id}',
                ),
                label: 'New Room',
                icon: Icons.people_alt_rounded,
              ),
              buildPopupMenuItem(
                context,
                onTap: () => context.push(
                  '${HomeScreen.id}/${SettingsScreen.id}',
                ),
                label: 'Settings',
                icon: Icons.settings_rounded,
              ),
            ],
          )
        ],
      ),
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
                    itemCount: room.value?.length,
                    itemBuilder: (context, index) {
                      final Room roomData = Room(
                        id: room.value![index]['id'],
                        creator: room.value?[index]['creator'],
                        creatorId: auth!.uid,
                        name: room.value?[index]['name'],
                        private: room.value?[index]['private'],
                        image: room.value?[index]['image'],
                      );

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
                      return StreamBuilder(
                          stream: firestore
                              .collection('rooms')
                              .doc(roomData.id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            String sender = user.value?['id'] == auth.uid
                                ? 'Me: '
                                : '${user.value?['title'] + ' ' + user.value?['fName']}: ';
                            String lastSent =
                                snapshot.data?.docs[0].data()['message'] ?? '';
                            DateTime timeStamp =
                                (snapshot.data?.docs[0].data()['time']) == null
                                    ? DateTime.now()
                                    : (snapshot.data?.docs[0].data()['time'])
                                        .toDate();
                            String time =
                                DateFormat('EE, hh:mm a').format(timeStamp);
                            return Visibility(
                              visible: visible,
                              child: RoomTile(
                                image: roomData.image!,
                                leading: Icons.people_rounded,
                                name: roomData.name,
                                subtitle: '$sender $lastSent',
                                dateTime: time,
                                onTap: () {
                                  context.push(
                                    '${HomeScreen.id}/${RoomScreen.id}',
                                    extra: roomData,
                                  );
                                },
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred'),
        ),
        loading: () => const LoadingIndicator(),
      ),
    );
  }

  PopupMenuItem<int> buildPopupMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required void Function()? onTap,
  }) {
    return PopupMenuItem(
      value: 1,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: ten),
          Text(label, style: const TextStyle(fontSize: 16.0)),
        ],
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
