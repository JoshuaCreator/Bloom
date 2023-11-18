import 'dart:async';
import 'package:basic_board/views/screens/dept_screen.dart';

import '../../utils/imports.dart';
import '../dialogues/message_details_screen.dart';

class RoomChatScreen extends ConsumerStatefulWidget {
  static String id = 'room-chat';
  const RoomChatScreen({
    super.key,
    required this.room,
    required this.deptId,
  });
  final Room room;
  final String deptId;

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
        .collection('departments')
        .doc(widget.room.deptId)
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
          // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          //   return const Center(
          //     child: Text('Be the first to send a message'),
          //   );
          // }
          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.only(bottom: ten),
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              bool isMe = user.value?['id'] == auth?.uid;

              final pending =
                  snapshot.data?.docs[index].metadata.hasPendingWrites;
              final Message message = Message(
                id: data[index].id,
                senderId: data[index]['senderId'],
                isMe: isMe,
                // senderName: data[index]['senderName'],
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
                    enableDrag: false,
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => MessageDetailsScreen(
                      room: widget.room,
                      message: message,
                      repliesRef:
                          collectionRef.doc(message.id).collection('replies'),
                      messageRef: collectionRef,
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
      persistentFooterButtons: buildTexter(
        context,
        user: user.value,
        bottom: bottom,
        senderId: auth?.uid,
      ),
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
            onTap: () => context.push(
              '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.deptId}/${RoomInfoScreen.id}/${widget.deptId}',
              extra: widget.room,
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
