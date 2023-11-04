import 'dart:async';

import 'package:basic_board/services/message_db.dart';
import 'package:basic_board/models/room.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/room_info_screen.dart';
import 'package:basic_board/views/dialogues/loading_indicator.dart';
import 'package:basic_board/views/widgets/message_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/models/message.dart';
import 'package:basic_board/views/widgets/message_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../dialogues/message_details_screen.dart';

class RoomChatScreen extends ConsumerStatefulWidget {
  static String id = 'room';
  const RoomChatScreen({super.key, required this.room});
  final Room room;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomChatScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool showUploadButtons = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>>? messageSnapshots;
  late CollectionReference collectionRef;

  @override
  void initState() {
    super.initState();
    messageSnapshots = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots(includeMetadataChanges: true);
    collectionRef = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages');
  }

  // Future<bool> checkConnectivity() async {
  //   var result = await Connectivity().checkConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    // checkConnectivity();
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider).value;

    double bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      appBar: buildAppBar(context),
      body: StreamBuilder(
        stream: messageSnapshots,
        builder: (_, snapshot) {
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
          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.only(bottom: ten),
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              bool isMe = user.value?['id'] == auth?.uid ? true : false;

              final pending =
                  snapshot.data?.docs[index].metadata.hasPendingWrites;
              final Message message = Message(
                id: data[index].id,
                senderId: data[index]['senderId'],
                isMe: isMe,
                senderName: data[index]['senderName'],
                message: data[index]['message'],
                // image: data?[index]['image'],
                time: (data[index]['time']).toDate(),
                pending: pending!,
              );
              return MessageTile(
                onTap: () {
                  showModalBottomSheet(
                    // anchorPoint: Offset(0, kBottomNavigationBarHeight),
                    showDragHandle: true,
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => MessageDetailsScreen(
                      message: message,
                      repliesSnapshots: collectionRef
                          .doc(message.id)
                          .collection('replies')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      repliesRef:
                          collectionRef.doc(message.id).collection('replies'),
                    ),
                  );
                },
                messageRef: collectionRef,
                message: message,
              );
            },
          );
        },
      ),
      persistentFooterButtons: user.value?['admin']
          ? buildTexter(
              context,
              user: user.value,
              bottom: bottom,
              senderId: auth?.uid,
            )
          : null,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.room.name,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: ten),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              enableDrag: false,
              context: context,
              builder: (context) => RoomInfoScreen(
                name: widget.room.name,
                desc: widget.room.desc ?? '',
                image: widget.room.image!,
                participants: widget.room.participants,
                participantsSnapshots: FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(widget.room.id).get(),
              ),
            ),
            child: Hero(
              tag: 'room-img',
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.room.image!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTexter(BuildContext context,
      {required Map<String, dynamic>? user,
      required double bottom,
      required String? senderId}) {
    return [
      Column(
        children: [
          Form(
            key: _key,
            child: Expanded(
              child: MessageTextField(
                hintText: 'Type a message',
                textController: _messageController,
                onPrefixPressed: () => setState(() {
                  if (showUploadButtons) {
                    Timer(const Duration(seconds: 10), () {
                      setState(() {
                        showUploadButtons = false;
                      });
                    });
                  } else {
                    showUploadButtons = true;
                    Timer(const Duration(seconds: 10), () {
                      setState(() {
                        showUploadButtons = false;
                      });
                    });
                  }
                }),
                onSuffixPressed: () {
                  if (_messageController.text.trim().isEmpty) return;
                  MessageDB().send(
                    ref: collectionRef,
                    Message(
                      senderId: senderId!,
                      message: _messageController.text.trim(),
                      time: DateTime.now(),
                      senderName: (user?['fName'] + ' ' + user?['lName'])
                          .toString()
                          .trim(),
                    ),
                    context,
                  );
                  _messageController.clear();
                },
              ),
            ),
          ),
          Visibility(
            visible: showUploadButtons,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.image_rounded),
                  tooltip: 'Upload an image file',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_file_rounded),
                  tooltip: 'Upload a video file',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file_rounded),
                  tooltip: 'Upload a document',
                ),
              ],
            ),
          ),
          SizedBox(height: bottom),
        ],
      ),
    ];
  }
}
