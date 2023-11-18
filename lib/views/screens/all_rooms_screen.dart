import 'package:basic_board/views/screens/dept_screen.dart';

import '../../utils/imports.dart';

class AllRoomsScreen extends ConsumerWidget {
  static String id = 'all-rooms';
  const AllRoomsScreen({super.key, required this.deptId});
  final String deptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomProvider(deptId));
    final auth = ref.watch(authStateProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Rooms'),
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
          return data.isEmpty
              ? const Center(
                  child: Text(
                    'There are no Rooms available in this Department yet.\n Contact your supervisor',
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(twenty, ten, ten, thirty),
                        child: Text(
                          'Here are all the Rooms in this Department',
                          style: TextStyle(fontSize: twenty),
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

                          final bool isParticipant =
                              roomData.participants.contains(auth.uid);

                          return RoomTile(
                            id: roomData.id!,
                            image: roomData.image!,
                            name: roomData.name,
                            subtitle: numberOfParticipants(),
                            trailing: isParticipant
                                ? AppTextButton(
                                    label: 'Leave',
                                    colour: ColourConfig.danger,
                                    onPressed: () {
                                      //? Leave Room
                                      leaveRoomDialogue(
                                        context,
                                        deptId: deptId,
                                        roomId: roomData.id!,
                                        userId: auth.uid,
                                        roomName: roomData.name,
                                      );
                                    },
                                  )
                                : AppTextButton(
                                    label: 'Join',
                                    colour: ColourConfig.go,
                                    onPressed: () {
                                      //? Join Room
                                      RoomDB().join(
                                        context,
                                        deptId: deptId,
                                        roomId: roomData.id!,
                                        userId: auth.uid,
                                        roomName: roomData.name,
                                      );
                                    },
                                  ),
                            onTap: () => context.push(
                              '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${RoomInfoScreen.id}',
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
