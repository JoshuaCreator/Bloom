import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/popup_menu.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:basic_board/views/dialogues/name_edit_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

import '../../configs/text_config.dart';
import 'loading_indicator.dart';

class RoomInfoScreen extends ConsumerWidget {
  static String id = 'room-info';
  const RoomInfoScreen({
    super.key,
    required this.name,
    required this.roomId,
    required this.desc,
    required this.image,
  });
  final String name;
  final String roomId;
  final String desc;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          AppPopupMenu(items: [
            AppPopupMenu.buildPopupMenuItem(
              context,
              label: 'Change Room info',
              onTap: () => nameEditDialogue(
                context,
                onSaved: () {
                  //! Save User Info
                },
              ),
            ),
          ]),
        ],
      ),
      body: FutureBuilder(
          future: firestore
              .collection('rooms')
              .doc(roomId)
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
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Be the first to send a message'),
              );
            }
            return ListView(
              shrinkWrap: true,
              // padding: EdgeInsets.only(top: ten, bottom: ten, left: ten, right: ten),
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
                          backgroundImage: CachedNetworkImageProvider(image),
                        ),
                      ),
                    ),
                    height20,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(name, style: TextStyle(fontSize: twenty)),
                        Text(numberOfParticipants()),
                      ],
                    ),
                    height10,
                    const Seperator(),
                    desc.isEmpty
                        ? AppTextButton(
                            onPressed: () => nameEditDialogue(
                              context,
                              showNameField: false,
                              isRoom: true,
                              onSaved: () {
                                //! Save User Info
                              },
                            ),
                            label: 'Add Room description',
                          )
                        : ReadMoreText(desc * 200),
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
                        final data = snapshot.data!.docs[index];
                        return ListTile(
                          onTap: () {},
                          leading: CircleAvatar(radius: circularAvatarRadius),
                          title: Text(data['fName'] + ' ' + data['lName']),
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
