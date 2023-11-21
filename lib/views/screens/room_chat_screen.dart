import 'dart:io';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/screens/dept_screen.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImageHelper imageHelper = ImageHelper();
  String? fileImage;

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);

    final collectionRef = firestore
        .collection('departments')
        .doc(widget.deptId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages');

    final messages = ref.watch(messagesProvider(firestore
        .collection('departments')
        .doc(widget.deptId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages')
        .orderBy('time', descending: true)));

    final auth = ref.watch(authStateProvider).value;

    double bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      appBar: buildAppBar(context),
      body: messages.when(
        data: (data) {
          return ListView.builder(
            padding: EdgeInsets.only(bottom: ten),
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = ref
                  .watch(anyUserProvider(messages.value?[index]['senderId']));
              bool isMe = user.value?['id'] == auth?.uid;

              final pending = data[index].metadata.hasPendingWrites;
              final Message message = Message(
                id: data[index].id,
                senderId: data[index]['senderId'] ?? '',
                isMe: isMe,
                message: data[index]['message'] ?? '',
                image: data[index]['image'] ?? '',
                time: (data[index]['time']).toDate(),
                pending: pending,
              );
              final repliesRef =
                  collectionRef.doc(message.id).collection('replies');
              return MessageTile(
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: false,
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) {
                      return MessageDetailsScreen(
                        room: widget.room,
                        message: message,
                        repliesRef: repliesRef,
                        messageRef: collectionRef,
                        deptId: widget.deptId,
                      );
                    },
                  );
                },
                messageRef: collectionRef,
                repliesRef: repliesRef,
                message: message,
                deptId: widget.deptId,
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('Oops! An error occurred'));
        },
        loading: () {
          return const Center(child: LoadingIndicator());
        },
      ),
      persistentFooterButtons: buildTexter(
        context,
        collectionRef: collectionRef,
        bottom: bottom,
        senderId: auth?.uid,
        firestore: firestore,
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
              tag: 'room-display-img',
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.room.image!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTexter(
    BuildContext context, {
    required CollectionReference collectionRef,
    required double bottom,
    required String? senderId,
    required FirebaseFirestore firestore,
  }) {
    return [
      Column(
        children: [
          Visibility(
            visible: fileImage != null,
            child: fileImage == null
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(bottom: ten),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox.square(
                          dimension: size * 7,
                          child: Image.file(File(fileImage!)),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              fileImage = null;
                            });
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  ),
          ),
          Visibility(
            visible: showUploadButtons,
            child: Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // UploadTile(text: 'Image'),
                      // SizedBox(width: ten),
                      // UploadTile(text: 'Video'),
                      // SizedBox(width: ten),
                      // UploadTile(text: 'Document'),

                      IconButton(
                        onPressed: () async {
                          String imagePath = await imageHelper.pickImage(
                            context,
                            source: ImageSource.gallery,
                          );
                          // if (context.mounted) {
                          //   showModalBottomSheet(
                          //     context: context,
                          //     useSafeArea: true,
                          //     isScrollControlled: true,
                          //     builder: (context) {
                          //       return Column(
                          //       );
                          //     },
                          //   );
                          // }
                          if (context.mounted) {
                            String croppedImg = await imageHelper
                                .cropImage(context, path: imagePath);
                            if (context.mounted) {
                              context.pop();
                              setState(() {
                                showUploadButtons = false;
                                fileImage = croppedImg;
                              });
                            }
                          }
                        },
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
                  height10,
                ],
              ),
            ),
          ),
          Form(
            key: _key,
            child: Expanded(
              child: MessageTextField(
                hintText: 'Type a message',
                textController: _messageController,
                onPrefixPressed: () => setState(() {
                  showUploadButtons
                      ? showUploadButtons = false
                      : showUploadButtons = true;
                  // if (showUploadButtons) {
                  //   Timer(const Duration(seconds: 10), () {
                  //     setState(() {
                  //       showUploadButtons = false;
                  //     });
                  //   });
                  // } else {
                  //   showUploadButtons = true;
                  //   Timer(const Duration(seconds: 10), () {
                  //     setState(() {
                  //       showUploadButtons = false;
                  //     });
                  //   });
                  // }
                }),
                onSuffixPressed: () {
                  if (_messageController.text.trim().isEmpty &&
                      fileImage!.isEmpty) return;

                  MessageDB().send(
                    ref: collectionRef,
                    deptId: widget.deptId,
                    roomId: widget.room.id!,
                    filePath: fileImage,
                    Message(
                      senderId: senderId!,
                      message: _messageController.text.trim(),
                      time: DateTime.now(),
                    ),
                    context,
                  );
                  _messageController.clear();
                  FocusManager.instance.primaryFocus!.unfocus();
                  setState(() {
                    fileImage = null;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: bottom),
        ],
      ),
    ];
  }
}

class UploadTile extends StatelessWidget {
  const UploadTile({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: twenty),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: defaultBorderRadius,
            border: Border.all(),
          ),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
