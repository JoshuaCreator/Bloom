import 'dart:async';

import 'package:basic_board/services/message_db.dart';
import 'package:basic_board/models/room.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/screens/room_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/models/message.dart';
import 'package:basic_board/views/widgets/notice_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomScreen extends ConsumerStatefulWidget {
  static String id = 'room';
  const RoomScreen({super.key, required this.room});
  final Room room;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool showUploadButtons = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> messageSnapshots;
  late CollectionReference collectionRef;

  @override
  void initState() {
    super.initState();
    messageSnapshots = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      collectionRef = FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.room.id)
          .collection('messages');
    });
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

    double bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
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
                builder: (context) => const RoomInfoScreen(),
              ),
              child: const CircleAvatar(),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: messageSnapshots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return const Center(child: Text("No messages"));
          }
          if (snapshot.hasError) {
            const Center(child: Text("Oops! An error occurred"));
          }
          final data = snapshot.data?.docs;
          return ListView.builder(
            reverse: true,
            itemCount: data?.length,
            itemBuilder: (context, index) {
              return NoticeTile(
                notice: Message(
                  sender: data?[index]['sender'],
                  message: data?[index]['message'],
                  // image: data?[index]['image'],
                  time: (data?[index]['time']).toDate(),
                ),
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
            )
          : null,
    );
  }

  List<Widget> buildTexter(
    BuildContext context, {
    required Map<String, dynamic>? user,
    required double bottom,
  }) {
    return [
      Column(
        children: [
          Form(
            key: _key,
            child: Expanded(
              child: TextField(
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus!.unfocus(),
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () => setState(() {
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
                    icon: const Icon(Icons.attach_file_rounded),
                    tooltip: 'Attach file',
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_messageController.text.trim().isEmpty) return;
                      MessageDB().send(
                        ref: collectionRef,
                        Message(
                          message: _messageController.text.trim(),
                          time: DateTime.now(),
                          sender: (user?['title'] +
                                  ' ' +
                                  user?['fName'] +
                                  ' ' +
                                  user?['lName'])
                              .toString()
                              .trim(),
                        ),
                        context,
                      );
                      _messageController.clear();
                    },
                    icon: const Icon(Icons.send_rounded),
                    tooltip: 'Send',
                  ),
                  contentPadding: EdgeInsets.only(
                    right: ten,
                    top: five,
                    bottom: five,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                controller: _messageController,
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






// body: anouncement.when(
//         data: (data) {
//           return data.isEmpty
//               ? const Center(child: Text("No messages"))
//               : ListView.builder(
//                   reverse: true,
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     return NoticeTile(
//                       notice: Message(
//                         sender: data[index]['sender'],
//                         message: data[index]['message'],
//                         image: data[index]['image'],
//                         time: (data[index]['time']).toDate(),
//                       ),
//                     );
//                   },
//                 );
//         },
//         error: (error, stackTrace) => const Center(
//           child: Text('Oops! An error occurred'),
//         ),
//         loading: () => const Center(child: CircularProgressIndicator()),
//       ),