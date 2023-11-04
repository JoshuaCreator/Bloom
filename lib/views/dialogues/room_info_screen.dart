import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/dialogues/popup_menu.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:basic_board/views/dialogues/name_edit_dialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../configs/text_config.dart';

class RoomInfoScreen extends StatelessWidget {
  static String id = 'room-info';
  const RoomInfoScreen({
    super.key,
    required this.name,
    required this.desc,
    required this.image,
    this.participants,
    required this.participantsSnapshots,
  });
  final String name;
  final String desc;
  final String image;
  final List? participants;
  final Future<Object?>? participantsSnapshots;

  @override
  Widget build(BuildContext context) {
    String numberOfParticipants() {
      if (participants!.isEmpty) {
        return ' • 0 participants';
      } else if (participants!.length == 1) {
        return ' • 1 participant';
      } else {
        return ' • ${participants!.length} participants';
      }
    }

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
      body: ListView(
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
              FutureBuilder(
                future: participantsSnapshots,
                builder: (context, snapshots) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // itemCount: snapshots.data.,
                    itemBuilder: (context, index) {
                      final user = FirebaseFirestore.instance
                          .collection('users')
                          .where('id', whereIn: participants);

                      // final n = user.snapshots().map((event) => event.docs);
                      // final String name = n.;
                      return ListTile(
                        onTap: () {},
                        leading: CircleAvatar(radius: circularAvatarRadius),
                        title: Text('Joshua Ewaoche'),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ten,
                          vertical: five,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          height10,
        ],
      ),
    );
  }
}
