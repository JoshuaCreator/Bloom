import '../../utils/imports.dart';

class AllRoomsScreen extends ConsumerWidget {
  static String id = 'all-rooms';
  const AllRoomsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider);
    final auth = ref.watch(authStateProvider).value;
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
                                leaveRoomDialogue(
                                  context,
                                  roomId: roomData.id!,
                                  userId: auth.uid,
                                  roomName: roomData.name,
                                );
                              }
                            : () {
                                //? Join Room
                                RoomDB().join(
                                  context,
                                  roomId: roomData.id!,
                                  userId: auth.uid,
                                  roomName: roomData.name,
                                );
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
