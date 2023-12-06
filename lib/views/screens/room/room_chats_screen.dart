import 'package:basic_board/providers/room/message_data_providers.dart';
import 'package:basic_board/providers/room/room_data_providers.dart';

import '../../../providers/users_providers.dart';
import '../../../utils/imports.dart';

class RoomChatsScreen extends ConsumerStatefulWidget {
  static String id = 'room-chats';
  const RoomChatsScreen({super.key, this.space});
  final Space? space;

  @override
  ConsumerState<RoomChatsScreen> createState() => _RoomChatsScreenState();
}

class _RoomChatsScreenState extends ConsumerState<RoomChatsScreen> {
  bool showRooms = true;
  bool chatsVisible = true;
  double turns = 0.0;
  double chatsTurns = 0.0;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(spaceRoomsProvider(widget.space!.id!));
    final auth = ref.watch(authStateProvider).value;
    final firestore = ref.watch(firestoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.space?.name ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                '${SpaceScreen.id}/${RoomChatsScreen.id}/${SpaceInfoScreen.id}',
                extra: widget.space,
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: room.when(
        data: (data) => data.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(twenty),
                  child: const Text(
                    'You have not joined any Rooms in this Space yet',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: ten),
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
                    createdAt: (room.value?[index]['createdAt']).toDate(),
                    participants: room.value?[index]['participants'],
                  );
                  final lastMessage = ref.watch(
                    lastMessageProvider(firestore
                        .collection('spaces')
                        .doc(widget.space?.id)
                        .collection('rooms')
                        .doc(roomData.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .limit(1)),
                  );
                  final String senderId =
                      lastMessage.value == null || lastMessage.value!.isEmpty
                          ? ''
                          : lastMessage.value?[0]['senderId'];

                  final user = ref.watch(anyUserProvider(senderId));

                  final bool me = auth?.uid == senderId;

                  final String last =
                      lastMessage.value == null || lastMessage.value!.isEmpty
                          ? ''
                          : lastMessage.value?[0]['message'];

                  final String subtitle =
                      lastMessage.value == null || lastMessage.value!.isEmpty
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
                      spaceId: widget.space?.id,
                      onTap: () {
                        context.push(
                          '${SpaceScreen.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.space!.id}',
                          extra: roomData,
                        );
                      },
                    ),
                  );
                },
              ),
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred'),
        ),
        loading: () => const LoadingIndicator(),
      ),
    );
  }
}
