import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/dialogues/popup_menu.dart';
import 'package:basic_board/views/dialogues/snack_bar.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:basic_board/views/dialogues/info_edit_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../configs/text_config.dart';
import '../../models/room.dart';
import '../../services/date_time_formatter.dart';
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
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final user = ref.watch(userProvider).value!;
    final auth = ref.watch(authStateProvider).value!;
    final nameController = TextEditingController(text: widget.room.name);
    final aboutController = TextEditingController(text: widget.room.desc);
    return Scaffold(
      appBar: AppBar(
        actions: auth.uid == widget.room.creatorId
            ? [
                AppPopupMenu(items: [
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
                        firestore
                            .collection('rooms')
                            .doc(widget.room.id)
                            .update({
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
                            msg:
                                'Oops! Unable to update Room info. \n Try again',
                          );
                        });
                      },
                    ),
                  ),
                ]),
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
            String numberOfParticipants() {
              if (snapshot.data!.docs.isEmpty) {
                return ' • 0 participants';
              } else if (snapshot.data!.docs.length == 1) {
                return ' • 1 participant';
              } else {
                return ' • ${snapshot.data!.docs.length} participants';
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Oops! An error occurred"));
            }
            if (!snapshot.hasData) {
              return const Center();
            }
            return ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      // onTap: () => imagePickerDialogue(
                      //   context,
                      //   onStorageTapped: () {
                      //     //! Pick Image From Device Storage
                      //   },
                      //   onCameraTapped: () {
                      //     //! Pick Image From Camera
                      //   },
                      // ),
                      child: Hero(
                        tag: 'room-img',
                        child: CircleAvatar(
                          radius: size * 2,
                          backgroundImage:
                              CachedNetworkImageProvider(widget.room.image!),
                        ),
                      ),
                    ),
                    height20,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.room.name,
                          style: TextStyle(fontSize: twenty),
                        ),
                        Text(numberOfParticipants()),
                      ],
                    ),
                    height10,
                    Wrap(
                      children: [
                        Text(
                          'Created by ${widget.room.creator} ${timeAgo(widget.room.createdAt!)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
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
                          child: Text('Participants', style: TextConfig.intro),
                        ),
                      ],
                    ),
                    height10,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.size,
                      itemBuilder: (context, index) {
                        // final data = snapshot.data!.docs[index];
                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: circularAvatarRadius,
                            backgroundImage: CachedNetworkImageProvider(
                              user['image'],
                            ),
                          ),
                          title: Text('${user['name']}'),
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
}
