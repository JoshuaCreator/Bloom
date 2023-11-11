import 'package:basic_board/views/dialogues/popup_menu.dart';
import 'package:basic_board/views/screens/all_rooms_screen.dart';
import 'package:basic_board/views/screens/room_chat_screen.dart';
import 'package:basic_board/views/dialogues/loading_indicator.dart';
import 'package:basic_board/views/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../configs/consts.dart';
import '../../models/room.dart';
import '../../providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import '../../services/date_time_formatter.dart';
import '../widgets/room_tile.dart';
import '../widgets/search_tile.dart';
import '../widgets/section_divider.dart';
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
    final room = ref.watch(roomProvider);
    final auth = ref.watch(authStateProvider).value;

    return Scaffold(
      // drawer: AppDrawer(room: room, user: user, auth: auth),
      appBar: AppBar(
        title: const Text("Joshua's chat app"),
        actions: [
          AppPopupMenu(
            items: [
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'New Room',
                onTap: () => context.push(
                  '${HomeScreen.id}/${CreateRoomScreen.id}',
                ),
              ),
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'Settings',
                onTap: () => context.push(
                  '${HomeScreen.id}/${SettingsScreen.id}',
                ),
              ),
            ],
          ),
        ],
      ),
      body: room.when(
        data: (data) => Column(
          children: [
            height10,
            SearchTile(
              label: 'search...',
              icon: Icons.search_rounded,
              onTap: () => showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              ),
            ),
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

                      bool showRoom() {
                        if (roomData.participants.contains(auth.uid)) {
                          return true;
                        } else {
                          return false;
                        }
                      }

                      return Visibility(
                        visible: showRoom(),
                        child: RoomTile(
                          image: roomData.image!,
                          name: roomData.name,
                          subtitle: 'Created ${timeAgo(timeStamp)}',
                          onTap: () {
                            context.push(
                              '${HomeScreen.id}/${RoomChatScreen.id}',
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
          ],
        ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred'),
        ),
        loading: () => const LoadingIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${HomeScreen.id}/${AllRoomsScreen.id}'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
