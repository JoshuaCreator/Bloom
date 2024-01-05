import 'dart:io';
import 'dart:ui';

import 'package:basic_board/providers/room/room_data_providers.dart';
import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/space_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SpaceInfoScreen extends ConsumerStatefulWidget {
  static String id = 'space-info';
  const SpaceInfoScreen({super.key, required this.space});
  final Space space;

  @override
  ConsumerState<SpaceInfoScreen> createState() =>
      _ConsumerSpaceInfoScreenState();
}

class _ConsumerSpaceInfoScreenState extends ConsumerState<SpaceInfoScreen> {
  ImageHelper imageHelper = ImageHelper();
  String? image;
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value!;
    final space = ref.watch(spaceDataProvider(widget.space.id!));
    final room = ref.watch(spaceRoomsProvider(widget.space.id!));
    final nameController = TextEditingController(text: space.value?['name']);
    final descController = TextEditingController(text: space.value?['desc']);
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return Scaffold(
      body: space.when(
        data: (data) {
          String dateTime = DateFormat('dd MMM yyy')
              .format(data?['createdAt'].toDate() ?? DateTime.now());
          final bool isCreator = auth.uid == widget.space.creatorId;
          final bool isParticipant = data?['participants'].contains(auth.uid);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  buildPopupMenu(
                    context,
                    nameController: nameController,
                    descController: descController,
                    firestore: firestore,
                    userId: auth.uid,
                    isSpaceParticipant: isParticipant,
                    isCreator: isCreator,
                  ),
                ],
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
                                    widget.space.image!) as ImageProvider,
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
                            visible: isCreator && isParticipant,
                            child: IconButton(
                              onPressed: () {
                                context.push(
                                  '${BNavBar.id}/${RoomChatsScreen.id}/${SpaceInfoScreen.id}/${CreateRoomScreen.id}/${widget.space.id!}',
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
                              'There are no Rooms in this Space yet',
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

                          final bool isRoomParticipant =
                              roomData.participants.contains(auth.uid);

                          final bool isSpaceParticipant =
                              data?['participants'].contains(auth.uid);

                          return RoomTile(
                            roomData: roomData,
                            subtitle:
                                'Participants (${roomData.participants.length})',
                            trailing: !isSpaceParticipant
                                ? null
                                : isRoomParticipant
                                    ? AppTextButton(
                                        label: 'Leave',
                                        colour: ColourConfig.danger,
                                        onPressed: () {
                                          //? Leave Room
                                          leaveRoomDialogue(
                                            context,
                                            spcId: widget.space.id!,
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
                                            spaceId: widget.space.id!,
                                            roomId: roomData.id!,
                                            userId: auth.uid,
                                            roomName: roomData.name,
                                          );
                                        },
                                      ),
                            onTap: () => !isSpaceParticipant
                                ? showSnackBar(
                                    context,
                                    msg:
                                        "You must be a participant of ${data?['name']} to view this Room's details",
                                  )
                                : context.push(
                                    '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.space.id!}/${RoomInfoScreen.id}/${widget.space.id!}',
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
    required String userId,
    required bool isSpaceParticipant,
    required bool isCreator,
  }) {
    return AppPopupMenu(
      items: isCreator && isSpaceParticipant
          ? [
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
                          String croppedImg = await imageHelper
                              .cropImage(context, path: imagePath);
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
                                  .collection('spaces')
                                  .doc(widget.space.id!),
                              storagePath: 'spaces/${widget.space.id!}.png',
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
                          String croppedImg = await imageHelper
                              .cropImage(context, path: imagePath);
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
                                  .collection('spaces')
                                  .doc(widget.space.id!),
                              storagePath: 'spaces/${widget.space.id!}.png',
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
                label: 'Edit Space info',
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
                        SpaceDB().edit(
                          context,
                          spaceId: widget.space.id!,
                          name: nameController.text.trim(),
                          desc: descController.text.trim(),
                        );
                      },
                    );
                  }
                },
              ),
              isSpaceParticipant
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Space',
                      onTap: () async {
                        bool isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          leaveSpaceDialogue(
                            context,
                            space: widget.space,
                            spaceName: widget.space.name,
                            userId: userId,
                          );
                        }
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Space',
                      onTap: () async {
                        bool isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          SpaceDB().join(
                            context,
                            space: widget.space,
                            userId: userId,
                          );
                        }
                      },
                    ),
            ]
          : [
              isSpaceParticipant
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Space',
                      onTap: () async {
                        bool isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          leaveSpaceDialogue(
                            context,
                            space: widget.space,
                            spaceName: widget.space.name,
                            userId: userId,
                          );
                        }
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Space',
                      onTap: () async {
                        bool isConnected = await isOnline();
                        if (!isConnected) {
                          if (context.mounted) {
                            showSnackBar(context, msg: "You're offline");
                          }
                          return;
                        }
                        if (context.mounted) {
                          SpaceDB().join(
                            context,
                            space: widget.space,
                            userId: userId,
                          );
                        }
                      },
                    ),
            ],
    );
  }
}
