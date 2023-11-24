import '../../utils/imports.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String id = 'home';
  const HomeScreen({super.key, this.workspace});
  final Workspace? workspace;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool showRooms = true;
  bool chatsVisible = true;
  double turns = 0.0;
  double chatsTurns = 0.0;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(wrkspcRoomsProvider(widget.workspace!.id!));
    final auth = ref.watch(authStateProvider).value;
    final firestore = ref.watch(firestoreProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(
        wrkspcRoomsProvider(widget.workspace!.id!).future,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.workspace!.name),
          actions: [
            IconButton(
              onPressed: () => context.push(
                '${WorkspaceScreen.id}/${HomeScreen.id}/${WorkspaceInfoScreen.id}',
                extra: widget.workspace,
              ),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Workspace info',
            ),
          ],
        ),
        body: room.when(
          data: (data) => data.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(twenty),
                    child: const Text(
                      'You have not joined any Rooms in this Workspace yet',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
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
                      turns: turns,
                      onTap: () => setState(() {
                        showRooms ? showRooms = false : showRooms = true;
                        showRooms ? turns -= 1.0 / 2.0 : turns += 1.0 / 2.0;
                      }),
                    ),
                    VisibilityAnimator(
                      show: showRooms,
                      child: ListView.builder(
                        itemCount: room.value?.length,
                        itemBuilder: (context, index) {
                          final Room roomData = Room(
                            id: room.value![index]['id'],
                            creatorId: room.value?[index]['creatorId'],
                            name: room.value?[index]['name'],
                            desc: room.value?[index]['desc'],
                            private: room.value?[index]['private'],
                            image: room.value?[index]['image'] == null ||
                                    room.value?[index]['image']!.isEmpty
                                ? defaultRoomImg
                                : room.value?[index]['image'],
                            createdAt:
                                (room.value?[index]['createdAt']).toDate(),
                            participants: room.value?[index]['participants'],
                          );
                          final lastMessage = ref.watch(
                            lastMessageProvider(firestore
                                .collection('workspaces')
                                .doc(widget.workspace?.id)
                                .collection('rooms')
                                .doc(roomData.id)
                                .collection('messages')
                                .orderBy('time', descending: true)
                                .limit(1)),
                          );
                          final String senderId = lastMessage.value == null ||
                                  lastMessage.value!.isEmpty
                              ? ''
                              : lastMessage.value?[0]['senderId'];

                          final user = ref.watch(anyUserProvider(senderId));

                          final bool me = auth?.uid == senderId;

                          final String last = lastMessage.value == null ||
                                  lastMessage.value!.isEmpty
                              ? ''
                              : lastMessage.value?[0]['message'];

                          final String subtitle = lastMessage.value == null ||
                                  lastMessage.value!.isEmpty
                              ? 'No messages yet'
                              : me
                                  ? '~me: $last'
                                  : '~${user.value?['name'] ?? ''}: $last';

                          return Visibility(
                            visible: roomData.participants.contains(auth?.uid),
                            child: RoomTile(
                              showInfoIcon: true,
                              roomData: roomData,
                              subtitle: subtitle,
                              wrkspcId: widget.workspace?.id,
                              onTap: () {
                                context.push(
                                  '${WorkspaceScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.workspace!.id}',
                                  extra: roomData,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          error: (error, stackTrace) => const Center(
            child: Text('An error occurred'),
          ),
          loading: () => const LoadingIndicator(),
        ),
      ),
    );
  }
}

class VisibilityAnimator extends StatelessWidget {
  const VisibilityAnimator(
      {super.key, required this.show, required this.child});
  final bool show;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AnimatedSize(
        alignment: Alignment.bottomCenter,
        curve: Curves.ease,
        duration: Duration(milliseconds: animationDuration),
        reverseDuration: Duration(milliseconds: animationDuration),
        child: Visibility(visible: show, child: child),
      ),
    );
  }
}
