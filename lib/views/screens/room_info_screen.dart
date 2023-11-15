import 'dart:io';

import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/services/room_db.dart';
import 'package:basic_board/views/dialogues/app_dialogues.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/dialogues/popup_menu.dart';
import 'package:basic_board/views/dialogues/snack_bar.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:basic_board/views/dialogues/info_edit_dialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import '../../configs/text_config.dart';
import '../../models/room.dart';
import '../../services/date_time_formatter.dart';
import '../dialogues/bottom_sheets.dart';
import '../dialogues/loading_indicator.dart';

class RoomInfoScreen extends ConsumerStatefulWidget {
  static String id = 'room-info';
  const RoomInfoScreen({
    super.key,
    required this.room,
  });
  final Room room;

  @override
  ConsumerState<RoomInfoScreen> createState() => _ConsumerRoomInfoScreenState();
}

class _ConsumerRoomInfoScreenState extends ConsumerState<RoomInfoScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final user = ref.watch(userProvider).value;
    final auth = ref.watch(authStateProvider).value!;
    final nameController = TextEditingController(text: widget.room.name);
    final aboutController = TextEditingController(text: widget.room.desc);
    return Scaffold(
      appBar: AppBar(
        actions: auth.uid == widget.room.creatorId
            ? [
                buildMenu(
                  context,
                  nameController: nameController,
                  aboutController: aboutController,
                  firestore: firestore,
                  userId: auth.uid,
                ),
              ]
            : null,
      ),
      body: FutureBuilder(
          future: firestore
              .collection('rooms')
              .doc(widget.room.id)
              .collection('participants')
              .get(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Oops! An error occurred"));
            }
            if (!snapshot.hasData) {
              return const Center();
            }
            String? numberOfParticipants() {
              if (snapshot.data!.docs.isEmpty) {
                return '0 participants';
              } else if (snapshot.data!.docs.length == 1) {
                return '1 participant';
              } else {
                return '${snapshot.data!.docs.length} participants';
              }
            }

            return ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => imagePickerDialogue(
                        context,
                        onStorageTapped: () {
                          _pickImage(ImageSource.gallery).then((value) {
                            showLoadingIndicator(context, label: 'Saving...');
                            _uploadImage(
                              context,
                              image: image,
                              roomRef: firestore
                                  .collection('rooms')
                                  .doc(widget.room.id!),
                              userId: widget.room.id!,
                            ).then((value) => context.pop());
                          });
                        },
                        onCameraTapped: () {
                          _pickImage(ImageSource.camera).then((value) {
                            showLoadingIndicator(context, label: 'Saving...');
                            _uploadImage(
                              context,
                              image: image,
                              roomRef: firestore
                                  .collection('rooms')
                                  .doc(widget.room.id!),
                              userId: widget.room.id!,
                            ).then((value) => context.pop());
                          });
                        },
                      ),
                      child: Hero(
                        tag: 'room-img',
                        child: image == null
                            ? CircleAvatar(
                                radius: size * 2,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.room.image!),
                              )
                            : CircleAvatar(
                                radius: size * 2,
                                backgroundImage: FileImage(image!),
                              ),
                      ),
                    ),
                    height20,
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.room.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: twenty),
                        ),
                        Text(' • ${numberOfParticipants()}'),
                      ],
                    ),
                    height10,
                    FutureBuilder(
                      future: firestore
                          .collection('users')
                          .doc(widget.room.creatorId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Some one");
                        }
                        if (snapshot.hasError) {
                          return const Text("Some one");
                        }
                        final data = snapshot.data?.data();
                        return Text(
                          'Created by ${data?['name']} ${timeAgo(widget.room.createdAt!)}',
                          style: TextConfig.intro,
                        );
                      },
                    ),
                    height10,
                    const Seperator(),
                    widget.room.desc == '' && auth.uid == widget.room.creatorId
                        ? AppTextButton(
                            onPressed: () => infoEditDialogue(
                              context,
                              showName: false,
                              isRoom: true,
                              aboutController: aboutController,
                              onSaved: () {
                                if (aboutController.text.trim().isEmpty) {
                                  return;
                                }
                                showLoadingIndicator(context);
                                firestore
                                    .collection('rooms')
                                    .doc(widget.room.id)
                                    .update({
                                  'desc': aboutController.text.trim(),
                                }).then((value) {
                                  context.pop();
                                  context.pop();
                                  showSnackBar(
                                    context,
                                    msg: 'Room info updated successfully',
                                  );
                                }).catchError((e) {
                                  context.pop();
                                  showSnackBar(
                                    context,
                                    msg:
                                        'Oops! Unable to update Room info. \n Try again',
                                  );
                                });
                              },
                            ),
                            label: 'Add Room description',
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(vertical: ten),
                            child: ReadMoreText(widget.room.desc!),
                          ),
                    const Seperator(),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: ten),
                          child: Text(
                            numberOfParticipants() ?? '',
                            style: TextConfig.intro,
                          ),
                        ),
                      ],
                    ),
                    height10,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final bool me = user?['id'] == auth.uid;
                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: circularAvatarRadius,
                            backgroundImage: CachedNetworkImageProvider(
                              user?['image'],
                            ),
                          ),
                          title: Text(
                            me ? '${user?['name']} (You)' : '${user?['name']}',
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ten,
                            vertical: five,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    context.pop();
    showLoadingIndicator(context);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      await _cropImage(image);
      if (context.mounted && image == null) context.pop();
    } on PlatformException catch (e) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: 'An error occurred: $e');
      }
    }
  }

  Future<void> _cropImage(XFile? image) async {
    final ImageCropper cropper = ImageCropper();
    if (image != null) {
      final CroppedFile? croppedImg =
          await cropper.cropImage(sourcePath: image.path);
      final File temporaryImage = File(croppedImg!.path);
      setState(() {
        this.image = temporaryImage;
      });

      if (context.mounted) context.pop();
    }
  }

  AppPopupMenu buildMenu(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController aboutController,
    required FirebaseFirestore firestore,
    required String userId,
  }) {
    return AppPopupMenu(items: [
      AppPopupMenu.buildPopupMenuItem(
        context,
        label: 'Change Room info',
        onTap: () => infoEditDialogue(
          context,
          nameController: nameController,
          aboutController: aboutController,
          onSaved: () {
            if (nameController.text.trim().isEmpty) {
              return;
            }
            showLoadingIndicator(context);
            firestore.collection('rooms').doc(widget.room.id).update({
              'name': nameController.text.trim(),
              'desc': aboutController.text.trim(),
            }).then((value) {
              context.pop();
              context.pop();
              showSnackBar(
                context,
                msg: 'Room info updated successfully',
              );
            }).catchError((e) {
              context.pop();
              showSnackBar(
                context,
                msg: 'Oops! Unable to update Room info. \n Try again',
              );
            });
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
                  roomName: widget.room.name,
                  userId: userId,
                  roomId: widget.room.id!,
                  onComplete: () => context.pop(),
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
                  roomId: widget.room.id!,
                  userId: userId,
                  roomName: widget.room.name,
                );
              },
            ),
      widget.room.creatorId == userId
          ? AppPopupMenu.buildPopupMenuItem(
              context,
              label: 'Delete Room',
              onTap: () {
                deleteRoomDialogue(
                  context,
                  roomId: widget.room.id!,
                  roomName: widget.room.name,
                );
              },
            )
          : AppPopupMenu.buildPopupMenuItem(
              context,
              label: '',
              onTap: () {},
            ),
    ]);
  }
}

Future<void> _uploadImage(
  BuildContext context, {
  required File? image,
  required DocumentReference roomRef,
  required String userId,
}) async {
  final path = 'users/$userId/${image?.path}';
  try {
    final storageRef = FirebaseStorage.instance;

    final uploadTask = await storageRef.ref().child(path).putFile(image!);

    // final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    roomRef.update({'image': downloadUrl});
  } on FirebaseException catch (e) {
    if (context.mounted) showSnackBar(context, msg: 'An error occurred: $e');
  }
}
