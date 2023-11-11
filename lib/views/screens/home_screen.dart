import '../../utils/imports.dart';

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
    final firestore = ref.watch(firestoreProvider);

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
                        child: StreamBuilder(
                          stream: firestore
                              .collection('rooms')
                              .doc(roomData.id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            final senderId = snapshot.data?.docs[0]['senderId'];
                            final message = snapshot.data?.docs[0]['message'];
                            return StreamBuilder(
                              stream: firestore
                                  .collection('users')
                                  .doc(senderId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                final bool me = auth.uid == senderId;
                                final sender = snapshot.data?.data()?['name'];
                                return RoomTile(
                                  image: roomData.image!,
                                  name: roomData.name,
                                  subtitle: me
                                      ? '~me: $message'
                                      : '~$sender: $message',
                                  onTap: () {
                                    context.push(
                                      '${HomeScreen.id}/${RoomChatScreen.id}',
                                      extra: roomData,
                                    );
                                  },
                                );
                              },
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
