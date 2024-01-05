import 'dart:io';
import 'package:basic_board/providers/room/message_data_providers.dart';
import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/imports.dart';
import '../../dialogues/message_details_screen.dart';

class RoomMsgScreen extends ConsumerStatefulWidget {
  static String id = 'room-chat';
  const RoomMsgScreen({
    super.key,
    required this.room,
    required this.spaceId,
  });
  final Room room;
  final String spaceId;

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
        .collection('spaces')
        .doc(widget.spaceId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages');

    final messages = ref.watch(messagesProvider(firestore
        .collection('spaces')
        .doc(widget.spaceId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages')
        .orderBy('time', descending: true)));

    final auth = ref.watch(authStateProvider).value;

    double bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: DividerThemeData(color: ColourConfig.transparent),
      ),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: messages.when(
          data: (data) {
            return data.isEmpty
                ? Center(
                    child: Text('This is the begining of ${widget.room.name}'),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: ten),
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final user = ref.watch(anyUserProvider(
                          messages.value?[index]['senderId'] ?? ''));
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
                                spaceId: widget.spaceId,
                              );
                            },
                          );
                        },
                        messagesRef: collectionRef,
                        repliesRef: repliesRef,
                        message: message,
                        spaceId: widget.spaceId,
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
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.room.name, overflow: TextOverflow.ellipsis),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: ten),
          child: GestureDetector(
            onTap: () => context.push(
              '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.spaceId}/${RoomInfoScreen.id}/${widget.spaceId}',
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
                    spaceId: widget.spaceId,
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
