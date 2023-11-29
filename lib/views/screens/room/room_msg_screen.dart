import 'dart:io';
import 'package:basic_board/providers/room/message_data_providers.dart';
import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/imports.dart';
import '../../dialogues/message_details_screen.dart';

class RoomMsgScreen extends ConsumerStatefulWidget {
  static String id = 'room-chat';
  const RoomMsgScreen({
    super.key,
    required this.room,
    required this.wrkspc,
  });
  final Room room;
  final String wrkspc;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomMsgScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool showUploadButtons = false;
  final ImageHelper imageHelper = ImageHelper();
  String? fileImage;

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);

    final collectionRef = firestore
        .collection('workspaces')
        .doc(widget.wrkspc)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages');

    final messages = ref.watch(messagesProvider(firestore
        .collection('workspaces')
        .doc(widget.wrkspc)
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
              final user = ref.watch(
                  anyUserProvider(messages.value?[index]['senderId'] ?? ''));
              bool isMe = user.value?['id'] == auth?.uid;

              final pending = data[index].metadata.hasPendingWrites;
              final Message message = Message(
                id: data[index].id,
                senderId: data[index]['senderId'] ?? 'random_string',
                me: isMe,
                message: data[index]['message'] ?? '',
                image: data[index]['image'] ?? '',
                time: (data[index]['time']).toDate(),
                pending: pending,
                likes: data[index]['likes'],
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
                    useRootNavigator: true,
                    builder: (context) {
                      return MessageDetailsScreen(
                        room: widget.room,
                        message: message,
                        repliesRef: repliesRef,
                        messageRef: collectionRef,
                        wrkspcId: widget.wrkspc,
                      );
                    },
                  );
                },
                messagesRef: collectionRef,
                repliesRef: repliesRef,
                message: message,
                wrkspcId: widget.wrkspc,
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
              '${WorkspaceScreen.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.wrkspc}/${RoomInfoScreen.id}/${widget.wrkspc}',
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
          Form(
            key: _key,
            child: Expanded(
              child: MessageTextField(
                hintText: 'Type a message',
                textController: _messageController,
                onPrefixPressed: () async {
                  String imagePath = await imageHelper.pickImage(
                    context,
                    source: ImageSource.gallery,
                  );
                  if (context.mounted) {
                    String croppedImg =
                        await imageHelper.cropImage(context, path: imagePath);
                    if (context.mounted) {
                      context.pop();
                      setState(() {
                        showUploadButtons = false;
                        fileImage = croppedImg;
                      });
                    }
                  }
                },
                onSend: () {
                  if (_messageController.text.trim().isEmpty &&
                      fileImage!.isEmpty) return;

                  MessageDB().send(
                    ref: collectionRef,
                    wrkspcId: widget.wrkspc,
                    roomId: widget.room.id!,
                    Message(
                      senderId: senderId!,
                      message: _messageController.text.trim(),
                      image: fileImage,
                      time: DateTime.now(),
                      likes: [],
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
