import 'package:basic_board/models/dept.dart';
import 'package:basic_board/services/dept_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/dept_screen.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';
import 'package:intl/intl.dart';

class DeptInfoScreen extends ConsumerStatefulWidget {
  static String id = 'dept-info';
  const DeptInfoScreen({super.key, required this.deptData});
  final Department deptData;

  @override
  ConsumerState<DeptInfoScreen> createState() => _ConsumerDeptInfoScreenState();
}

class _ConsumerDeptInfoScreenState extends ConsumerState<DeptInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final dept = ref.watch(deptDataProvider(widget.deptData.id!));
    final room = ref.watch(deptRoomsProvider(widget.deptData.id!));
    final auth = ref.watch(authStateProvider).value;
    final nameController = TextEditingController(text: dept.value?['name']);
    final descController = TextEditingController(text: dept.value?['desc']);
    return Scaffold(
      appBar: AppBar(
        actions: auth?.uid == widget.deptData.creatorId && dept.value != null
            ? [
                buildPopupMenu(
                  context,
                  nameController: nameController,
                  descController: descController,
                ),
              ]
            : null,
      ),
      body: dept.when(
        data: (data) {
          String dateTime = DateFormat('dd MMM yyy')
              .format(data?['createdAt'].toDate() ?? DateTime.now());
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  height30,
                  Text.rich(
                    TextSpan(
                      text: '${data?['name'] ?? ''}\n',
                      children: [
                        TextSpan(
                          text: 'Created $dateTime',
                          style: TextStyle(
                            fontSize: ten + five,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: twenty),
                  ),
                  height30,
                  const Separator(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ten),
                    child: AppShowMoreText(text: data?['desc'] ?? ''),
                  ),
                  const Separator(),
                  Padding(
                    padding: EdgeInsets.only(left: ten),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rooms (${data?['rooms'].length ?? 0})',
                          style: TextConfig.intro,
                        ),
                        Visibility(
                          visible: auth?.uid == widget.deptData.creatorId,
                          child: IconButton(
                            onPressed: () {
                              context.push(
                                '${DeptScreen.id}/${HomeScreen.id}/${CreateRoomScreen.id}/${widget.deptData.id!}',
                              );
                            },
                            icon: const Icon(Icons.add),
                            tooltip: 'Add Room',
                          ),
                        ),
                      ],
                    ),
                  ),
                  height10,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: room.value?.length,
                    itemBuilder: (context, index) {
                      DateTime timeStamp =
                          (room.value?[index]['createdAt']) == null
                              ? DateTime.now()
                              : (room.value?[index]['createdAt']).toDate();
                      final Room roomData = Room(
                        id: room.value![index]['id'],
                        creatorId: room.value?[index]['creatorId'],
                        name: room.value?[index]['name'],
                        desc: room.value?[index]['desc'],
                        private: room.value?[index]['private'],
                        image: room.value?[index]['image'] ??
                            'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
                        createdAt: timeStamp,
                        participants: room.value?[index]['participants'],
                      );

                      final bool isParticipant =
                          roomData.participants.contains(auth?.uid);
                      return RoomTile(
                        roomData: roomData,
                        image: roomData.image,
                        name: roomData.name,
                        subtitle:
                            'Participants (${roomData.participants.length})',
                        trailing: isParticipant
                            ? AppTextButton(
                                label: 'Leave',
                                colour: ColourConfig.danger,
                                onPressed: () {
                                  //? Leave Room
                                  leaveRoomDialogue(
                                    context,
                                    deptId: widget.deptData.id!,
                                    roomId: roomData.id!,
                                    userId: auth!.uid,
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
                                    deptId: widget.deptData.id!,
                                    roomId: roomData.id!,
                                    userId: auth!.uid,
                                    roomName: roomData.name,
                                  );
                                },
                              ),
                        onTap: () => context.push(
                          '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.deptData.id!}/${RoomInfoScreen.id}/${widget.deptData.id!}',
                          extra: roomData,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('An error occurred. Tap to refresh'),
              IconButton(
                onPressed: () => ref.refresh(deptsProvider),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        loading: () {
          return const Center(child: LoadingIndicator(label: 'Please wait...'));
        },
      ),
    );
  }

  AppPopupMenu buildPopupMenu(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController descController,
  }) {
    return AppPopupMenu(
      items: [
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Edit Dept info',
          onTap: () => infoEditDialogue(
            context,
            nameController: nameController,
            aboutController: descController,
            onSaved: () {
              if (nameController.text.trim().isEmpty) return;
              DeptDB().edit(
                context,
                deptId: widget.deptData.id!,
                name: nameController.text.trim(),
                desc: descController.text.trim(),
              );
            },
          ),
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Delete dept',
          onTap: () {
            deleteDepartmentDialogue(
              context,
              deptName: widget.deptData.name,
              deptId: widget.deptData.id!,
            );
          },
        ),
      ],
    );
  }
}
