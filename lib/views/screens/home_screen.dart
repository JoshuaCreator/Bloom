import 'package:basic_board/models/dept.dart';
import 'package:basic_board/views/screens/dept_screen.dart';

import '../../utils/imports.dart';
import 'dept_info_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String id = 'home';
  const HomeScreen({super.key, this.dept});
  final Department? dept;

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
    // final firstDept = ref.watch(deptsProvider);
    // final firstDeptId = firstDept.value?[0].id;
    final room = ref.watch(roomProvider(widget.dept!.id!));
    final auth = ref.watch(authStateProvider).value;

    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(widget.dept!.name),
        actions: [buildPopupMenu(context)],
      ),
      body: room.when(
        data: (data) => data.isEmpty
            ? const Center(
                child: Text(
                  'There are no Rooms available in this Department yet.\n Contact your supervisor',
                  textAlign: TextAlign.center,
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
                          // deptId: room.value![index][''],
                          creatorId: room.value?[index]['creatorId'],
                          name: room.value?[index]['name'],
                          desc: room.value?[index]['desc'],
                          private: room.value?[index]['private'],
                          image: room.value?[index]['image'] ??
                              'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
                          createdAt: (room.value?[index]['createdAt']).toDate(),
                          participants: room.value?[index]['participants'],
                        );

                        return Visibility(
                          visible: roomData.participants.contains(auth?.uid),
                          child: Consumer(builder: (context, ref, child) {
                            final lastMessage =
                                ref.watch(lastMessageProvider(roomData.id!));

                            final String senderId = lastMessage.value!.isEmpty
                                ? 'random_string'
                                : lastMessage.value?[0]['senderId'];

                            final user = ref.watch(anyUserProvider(senderId));

                            final bool me = auth?.uid == senderId;

                            final String last = lastMessage.value!.isEmpty
                                ? ''
                                : lastMessage.value?[0]['message'];

                            final String subtitle = lastMessage.value!.isEmpty
                                ? 'No messages yet'
                                : me
                                    ? '~me: $last'
                                    : '~${user.value?['name'] ?? ''}: $last';

                            return RoomTile(
                              id: roomData.id!,
                              image: roomData.image!,
                              name: roomData.name,
                              subtitle: subtitle,
                              onTap: () {
                                context.push(
                                  '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.dept!.id}',
                                  extra: roomData,
                                );
                              },
                            );
                          }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          '${DeptScreen.id}/${HomeScreen.id}/${AllRoomsScreen.id}/${widget.dept?.id}',
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  AppPopupMenu buildPopupMenu(BuildContext context) {
    return AppPopupMenu(
      items: [
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Dept info',
          onTap: () => context.push(
            '${DeptScreen.id}/${HomeScreen.id}/${DeptInfoScreen.id}',
            extra: widget.dept,
          ),
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'New Room',
          onTap: () => context.push(
            '${DeptScreen.id}/${HomeScreen.id}/${CreateRoomScreen.id}/${widget.dept!.id!}',
          ),
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Settings',
          onTap: () => context.push(
            '${DeptScreen.id}/${HomeScreen.id}/${SettingsScreen.id}',
          ),
        ),
      ],
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
