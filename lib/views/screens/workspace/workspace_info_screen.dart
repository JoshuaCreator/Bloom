import 'dart:io';
import 'dart:ui';

import 'package:basic_board/providers/room/room_data_providers.dart';
import 'package:basic_board/providers/workspace_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/workspace_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class WorkspaceInfoScreen extends ConsumerStatefulWidget {
  static String id = 'workspace-info';
  const WorkspaceInfoScreen({super.key, required this.workspace});
  final Workspace workspace;

  @override
  ConsumerState<WorkspaceInfoScreen> createState() =>
      _ConsumerWorkspaceInfoScreenState();
}

class _ConsumerWorkspaceInfoScreenState
    extends ConsumerState<WorkspaceInfoScreen> {
  ImageHelper imageHelper = ImageHelper();
  String? image;
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value;
    final wrkspc = ref.watch(wrkspcDataProvider(widget.workspace.id!));
    final room = ref.watch(wrkspcRoomsProvider(widget.workspace.id!));
    final nameController = TextEditingController(text: wrkspc.value?['name']);
    final descController = TextEditingController(text: wrkspc.value?['desc']);
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: wrkspc.when(
        data: (data) {
          String dateTime = DateFormat('dd MMM yyy')
              .format(data?['createdAt'].toDate() ?? DateTime.now());
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: auth?.uid == widget.workspace.creatorId &&
                        wrkspc.value != null
                    ? [
                        buildPopupMenu(
                          context,
                          nameController: nameController,
                          descController: descController,
                          firestore: firestore,
                        ),
                      ]
                    : null,
                expandedHeight: size * 8,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image != null
                                ? FileImage(File(image!))
                                : CachedNetworkImageProvider(
                                    widget.workspace.image!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.3),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  text: '${data?['name'] ?? ''}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Created $dateTime',
                                      style: TextStyle(
                                        fontSize: ten + five,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    height10,
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
                            data?['rooms'] == null
                                ? 'Rooms (0)'
                                : 'Rooms (${data?['rooms'].length})',
                            style: TextConfig.intro,
                          ),
                          Visibility(
                            visible: auth?.uid == widget.workspace.creatorId,
                            child: IconButton(
                              onPressed: () {
                                context.push(
                                  '${WorkspaceScreen.id}/${RoomChatsScreen.id}/${WorkspaceInfoScreen.id}/${CreateRoomScreen.id}/${widget.workspace.id!}',
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
                  ],
                ),
              ),
              data?['rooms'] == null || data?['rooms']!.isEmpty
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                        Center(
                          heightFactor: ten,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: twenty),
                            child: const Text(
                              'There are no Rooms in this Workspace yet',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: room.value?.length,
                        (context, index) {
                          DateTime timeStamp =
                              (room.value?[index]['createdAt']) == null
                                  ? DateTime.now()
                                  : (room.value?[index]['createdAt']).toDate();
                          final Room roomData = Room(
                            id: room.value?[index]['id'] ?? '',
                            creatorId: room.value?[index]['creatorId'] ?? '',
                            name: room.value?[index]['name'] ?? '',
                            desc: room.value?[index]['desc'] ?? '',
                            private: room.value?[index]['private'] ?? true,
                            image:
                                room.value?[index]['image'] ?? defaultRoomImg,
                            createdAt: timeStamp,
                            participants:
                                room.value?[index]['participants'] ?? [],
                          );

                          final bool isParticipant =
                              roomData.participants.contains(auth?.uid);

                          return RoomTile(
                            roomData: roomData,
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
                                        wrkspcId: widget.workspace.id!,
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
                                        wrkspcId: widget.workspace.id!,
                                        roomId: roomData.id!,
                                        userId: auth!.uid,
                                        roomName: roomData.name,
                                      );
                                    },
                                  ),
                            onTap: () => context.push(
                              '${WorkspaceScreen.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.workspace.id!}/${RoomInfoScreen.id}/${widget.workspace.id!}',
                              extra: roomData,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('An error occurred. Tap to refresh'),
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
    required FirebaseFirestore firestore,
  }) {
    return AppPopupMenu(
      items: [
        // AppPopupMenu.buildPopupMenuItem(
        //   context,
        //   label: 'Settings',
        //   onTap: () {
        //     context.push(
        //       '${WorkspaceScreen.id}/${ChatsScreen.id}/${WorkspaceInfoScreen.id}/${WorkspaceSettingsScreen.id}',
        //       extra: widget.workspace,
        //     );
        //   },
        // ),

        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Change display image',
          onTap: () async {
            bool isConnected = await isOnline();
            if (!isConnected) {
              if (context.mounted) {
                showSnackBar(context, msg: "You're offline");
              }
              return;
            }
            if (context.mounted) {
              imagePickerDialogue(
                context,
                onStorageTapped: () async {
                  context.pop();
                  String imagePath = await imageHelper.pickImage(
                    context,
                    source: ImageSource.gallery,
                  );
                  if (context.mounted) {
                    String croppedImg =
                        await imageHelper.cropImage(context, path: imagePath);
                    if (context.mounted) {
                      context.pop();
                      showLoadingIndicator(context, label: 'Saving...');
                    }
                    if (context.mounted) {
                      setState(() {
                        image = croppedImg;
                      });
                      await imageHelper.uploadImage(
                        context,
                        imagePath: croppedImg,
                        docRef: firestore
                            .collection('workspaces')
                            .doc(widget.workspace.id!),
                        storagePath: 'workspaces/${widget.workspace.id!}.png',
                      );
                      if (context.mounted) context.pop();
                    }
                  }
                },
                onCameraTapped: () async {
                  context.pop();
                  String imagePath = await imageHelper.pickImage(
                    context,
                    source: ImageSource.camera,
                  );
                  if (context.mounted) {
                    String croppedImg =
                        await imageHelper.cropImage(context, path: imagePath);
                    if (context.mounted) {
                      context.pop();
                      showLoadingIndicator(context, label: 'Saving...');
                    }
                    if (context.mounted) {
                      setState(() {
                        image = croppedImg;
                      });
                      await imageHelper.uploadImage(
                        context,
                        imagePath: croppedImg,
                        docRef: firestore
                            .collection('workspaces')
                            .doc(widget.workspace.id!),
                        storagePath: 'workspaces/${widget.workspace.id!}.png',
                      );
                      if (context.mounted) context.pop();
                    }
                  }
                },
              );
            }
          },
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Edit Workspace info',
          onTap: () async {
            bool isConnected = await isOnline();
            if (!isConnected) {
              if (context.mounted) {
                showSnackBar(context, msg: "You're offline");
              }
              return;
            }
            if (context.mounted) {
              infoEditDialogue(
                context,
                nameController: nameController,
                aboutController: descController,
                onSaved: () {
                  if (nameController.text.trim().isEmpty) return;
                  WorkspaceDB().edit(
                    context,
                    wrkspcId: widget.workspace.id!,
                    name: nameController.text.trim(),
                    desc: descController.text.trim(),
                  );
                },
              );
            }
          },
        ),
        AppPopupMenu.buildPopupMenuItem(
          context,
          label: 'Delete Workspace',
          onTap: () async {
            bool isConnected = await isOnline();
            if (!isConnected) {
              if (context.mounted) {
                showSnackBar(context, msg: "You're offline");
              }
              return;
            }
            if (context.mounted) {
              deleteWorkspaceDialogue(
                context,
                wrkspcName: widget.workspace.name,
                wrkspcId: widget.workspace.id!,
              );
            }
          },
        ),
      ],
    );
  }
}
