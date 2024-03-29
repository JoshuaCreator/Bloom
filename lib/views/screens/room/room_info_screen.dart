import 'dart:io';
import 'package:basic_board/providers/room/room_data_providers.dart';
import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/screens/user_screen.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';
import '../../../utils/imports.dart';
import 'package:image_picker/image_picker.dart';
import '../../dialogues/bottom_sheets.dart';
import '../../widgets/user_tile.dart';

class RoomInfoScreen extends ConsumerStatefulWidget {
  static String id = 'room-info';
  const RoomInfoScreen({super.key, required this.room, required this.spcId});
  final Room room;
  final String spcId;

  @override
  ConsumerState<RoomInfoScreen> createState() => _ConsumerRoomInfoScreenState();
}

class _ConsumerRoomInfoScreenState extends ConsumerState<RoomInfoScreen> {
  String? fileImage;
  final ImageHelper imageHelper = ImageHelper();
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value!;
    final creator = ref.watch(anyUserProvider(widget.room.creatorId));
    final room = ref.watch(roomProvider(firestore
        .collection('spaces')
        .doc(widget.spcId)
        .collection('rooms')
        .doc(widget.room.id)));
    final participants = ref.watch(participantsProvider(firestore
        .collection('spaces')
        .doc(widget.spcId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('participants')));
    final nameController = TextEditingController(text: room.value?['name']);
    final aboutController = TextEditingController(text: room.value?['desc']);
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildMenu(
            context,
            nameController: nameController,
            aboutController: aboutController,
            firestore: firestore,
            userId: auth.uid,
            isCreator: auth.uid == room.value?['creatorId'],
          ),
        ],
      ),
      body: participants.when(
        data: (data) {
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewer(
                        image: room.value?['image']!.isEmpty ||
                                room.value?['image'] == null
                            ? defaultRoomImgPath
                            : room.value?['image'],
                      ),
                    ),
                    child: Hero(
                      tag: 'room-display-img',
                      child: fileImage == null
                          ? CircleAvatar(
                              radius: size * 2,
                              backgroundImage: CachedNetworkImageProvider(
                                widget.room.image!.isEmpty ||
                                        widget.room.image == null
                                    ? defaultRoomImgPath
                                    : widget.room.image!,
                              ),
                            )
                          : CircleAvatar(
                              radius: size * 2,
                              backgroundImage: FileImage(File(fileImage!)),
                            ),
                    ),
                  ),
                  height20,
                  Text(
                    room.value?['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: twenty),
                  ),
                  height10,
                  Text(
                    'Created by ${creator.value?['name']} ${timeAgo(widget.room.createdAt!)}',
                    style: TextConfig.intro,
                  ),
                  height10,
                  const Separator(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionsTile(
                        icon: Icons.call_rounded,
                        onTap: () {
                          // TODO: Implement function
                        },
                      ),
                      const SizedBox(width: 20.0),
                      ActionsTile(
                        icon: Icons.videocam_rounded,
                        onTap: () {
                          // TODO: Implement function
                        },
                      ),
                    ],
                  ),
                  const Separator(),
                  Visibility(
                    visible: room.value!['desc'].toString().isNotEmpty,
                    child: Column(
                      children: [
                        AppShowMoreText(text: room.value?['desc']),
                        const Separator(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: ten),
                        child: Text(
                          'Participants(${widget.room.participants.length})',
                          style: TextConfig.intro,
                        ),
                      ),
                    ],
                  ),
                  height10,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final bool me = data[index]['id'] == auth.uid;
                      final anyUser =
                          ref.watch(anyUserProvider(data[index]['id'])).value;

                      return UserTile(
                        title: me
                            ? '${anyUser?['name']} (You)'
                            : '${anyUser?['name']}',
                        image: anyUser?['image'] ?? '',
                        tag: me ? '' : 'user-tag',
                        onTap: me
                            ? null
                            : () => context.push(
                                  '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.spcId}/${RoomInfoScreen.id}/${widget.spcId}/${UserScreen.id}/${data[index]['id']}',
                                ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text("Oops! An error occurred"));
        },
        loading: () {
          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }

  AppPopupMenu buildMenu(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController aboutController,
    required FirebaseFirestore firestore,
    required String userId,
    required bool isCreator,
  }) {
    return AppPopupMenu(
      items: isCreator
          ? [
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'Change display picture',
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
                        String imagePath = await imageHelper.pickImage(
                          context,
                          source: ImageSource.gallery,
                        );
                        if (context.mounted) {
                          String croppedImg = await imageHelper
                              .cropImage(context, path: imagePath);
                          if (context.mounted) {
                            context.pop();
                            context.pop();
                            showLoadingIndicator(context, label: 'Saving');
                          }
                          if (context.mounted) {
                            setState(() {
                              fileImage = croppedImg;
                            });
                            await imageHelper.uploadImage(
                              context,
                              imagePath: croppedImg,
                              docRef: firestore
                                  .collection('spaces')
                                  .doc(widget.spcId)
                                  .collection('rooms')
                                  .doc(widget.room.id),
                              storagePath: 'rooms/${widget.room.name}.png',
                            );
                            if (context.mounted) context.pop();
                          }
                        }
                      },
                      onCameraTapped: () async {
                        String imagePath = await imageHelper.pickImage(
                          context,
                          source: ImageSource.camera,
                        );
                        if (context.mounted) {
                          String croppedImg = await imageHelper
                              .cropImage(context, path: imagePath);
                          if (context.mounted) {
                            setState(() {
                              fileImage = croppedImg;
                            });
                            await imageHelper.uploadImage(
                              context,
                              imagePath: croppedImg,
                              docRef: firestore
                                  .collection('spaces')
                                  .doc(widget.spcId)
                                  .collection('rooms')
                                  .doc(widget.room.id),
                              storagePath: 'rooms/${widget.room.name}.png',
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
              AppPopupMenu.buildPopupMenuItem(
                context,
                label: 'Change Room info',
                onTap: () => infoEditDialogue(
                  context,
                  nameController: nameController,
                  aboutController: aboutController,
                  onSaved: () {
                    if (nameController.text.trim().isEmpty) return;
                    RoomDB().edit(
                      context,
                      spaceId: widget.spcId,
                      roomId: widget.room.id!,
                      name: nameController.text.trim(),
                      desc: aboutController.text.trim(),
                    );
                  },
                ),
              ),
              widget.room.participants.contains(userId)
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Room',
                      onTap: () {
                        //? Leave Room
                        leaveRoomDialogue(
                          context,
                          spcId: widget.spcId,
                          roomName: widget.room.name,
                          userId: userId,
                          roomId: widget.room.id!,
                        );
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Room',
                      onTap: () {
                        //? Join Room
                        RoomDB().join(
                          context,
                          spaceId: widget.spcId,
                          roomId: widget.room.id!,
                          userId: userId,
                          roomName: widget.room.name,
                        );
                      },
                    ),
            ]
          : [
              widget.room.participants.contains(userId)
                  ? AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Leave Room',
                      onTap: () {
                        leaveRoomDialogue(
                          context,
                          spcId: widget.spcId,
                          roomName: widget.room.name,
                          userId: userId,
                          roomId: widget.room.id!,
                        );
                      },
                    )
                  : AppPopupMenu.buildPopupMenuItem(
                      context,
                      label: 'Join Room',
                      onTap: () {
                        RoomDB().join(
                          context,
                          spaceId: widget.spcId,
                          roomId: widget.room.id!,
                          userId: userId,
                          roomName: widget.room.name,
                        );
                      },
                    ),
            ],
    );
  }
}

class ActionsTile extends StatelessWidget {
  const ActionsTile({
    super.key,
    required this.icon,
    this.onTap,
  });
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: defaultBorderRadius,
      child: Ink(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: ColourConfig.lightGrey),
          borderRadius: defaultBorderRadius,
        ),
        child: Icon(icon),
      ),
    );
  }
}
