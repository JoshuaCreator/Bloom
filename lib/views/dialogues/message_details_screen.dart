import 'package:basic_board/services/connection_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../utils/imports.dart';

class MessageDetailsScreen extends ConsumerStatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.wrkspcId,
    required this.room,
    required this.repliesRef,
    required this.messageRef,
  });
  final Message message;
  final String wrkspcId;
  final Room room;
  final CollectionReference repliesRef, messageRef;

  @override
  ConsumerState<MessageDetailsScreen> createState() =>
      _ConsumerMessageDetailsScreenState();
}

class _ConsumerMessageDetailsScreenState
    extends ConsumerState<MessageDetailsScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.message.senderId));
    final auth = ref.watch(authStateProvider).value!;
    final firestore = ref.watch(firestoreProvider);
    final msg = ref.watch(messageProvider(firestore
        .collection('workspaces')
        .doc(widget.wrkspcId)
        .collection('rooms')
        .doc(widget.room.id)
        .collection('messages')
        .doc(widget.message.id!)));
    final msgRef = widget.messageRef.doc(widget.message.id!);
    final replies = ref.watch(repliesProvider(widget.repliesRef));
    final bool me = auth.uid == widget.message.senderId;

    String dateTime = DateFormat('dd MMM hh:mm a').format(widget.message.time);
    double bottom = MediaQuery.viewInsetsOf(context).bottom + forty + ten;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        actions: [
          IconButton(
            onPressed: () => Clipboard.setData(
              ClipboardData(text: widget.message.image!),
            ).then(
              (value) => showSnackBar(context, msg: 'Copied to clipboard'),
            ),
            icon: const Icon(Icons.copy),
          )
        ],
      ),
      body: replies.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                MsgTile(
                  widget: widget,
                  user: user,
                  msg: msg,
                  firestore: firestore,
                  date: dateTime,
                  me: me,
                ),
                ReactionTile(
                  me: me,
                  msg: msg,
                  widget: widget,
                  auth: auth,
                  onLiked: () async {
                    bool isConnected = await isOnline();
                    if (!isConnected) {
                      if (context.mounted) {
                        showSnackBar(context, msg: "You're currently offline");
                      }
                      return;
                    }
                    msg.value?['likes'].contains(auth.uid)
                        ? setState(() {
                            msgRef.update({
                              'likes': FieldValue.arrayRemove([auth.uid])
                            });
                          })
                        : setState(
                            () {
                              msgRef.update({
                                'likes': FieldValue.arrayUnion([auth.uid])
                              });
                            },
                          );
                  },
                ),
                height10,
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: ten),
                      child: Text(
                        'Replies (${data.length})',
                        style: TextConfig.intro,
                      ),
                    )
                  ],
                ),
                height10,
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    DateTime timeStamp = (data[index]['time']) == null
                        ? DateTime.now()
                        : (data[index]['time']).toDate();
                    final bool pending = data[index].metadata.hasPendingWrites;
                    final Reply reply = Reply(
                      message: data[index]['reply'],
                      replySenderId: data[index]['replySenderId'],
                      toMessageId: widget.message.id!,
                      toSenderId: widget.message.senderId,
                      isMe: auth.uid == data[index]['replySenderId'],
                      pending: pending,
                      time: timeStamp,
                      likes: data[index]['likes'],
                    );

                    return ReplyTile(
                      reply: reply,
                      replyRef: widget.repliesRef.doc(data[index].id),
                      wrkspcId: widget.wrkspcId,
                    );
                  },
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('Oops! An error occurred'));
        },
        loading: () {
          return const Center(child: LoadingIndicator());
        },
      ),
      persistentFooterButtons: [
        Form(
          key: _key,
          child: MessageTextField(
            onSuffixPressed: () {
              if (_replyTextController.text.trim().isEmpty) return;
              MessageDB().reply(
                ref: widget.repliesRef,
                Reply(
                  message: _replyTextController.text.trim(),
                  replySenderId: auth.uid,
                  toMessageId: widget.message.id!,
                  toSenderId: widget.message.senderId,
                  time: DateTime.now(),
                  likes: [],
                ),
                context,
              );
              _replyTextController.clear();
              FocusManager.instance.primaryFocus!.unfocus();
            },
            hintText: 'Type a reply',
            textController: _replyTextController,
            hasPrefix: false,
          ),
        ),
        SizedBox(height: bottom),
      ],
    );
  }
}

class ReactionTile extends StatelessWidget {
  const ReactionTile({
    super.key,
    required this.me,
    required this.msg,
    required this.widget,
    required this.auth,
    required this.onLiked,
  });
  final bool me;
  final AsyncValue<Map<String, dynamic>?> msg;
  final MessageDetailsScreen widget;
  final User auth;
  final void Function()? onLiked;

  @override
  Widget build(BuildContext context) {
    final messageController =
        TextEditingController(text: msg.value?['message']);
    return Column(
      children: [
        const Separator(height: 0),
        height5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ReactionButton(
              label: msg.value?['likes'] == null || msg.value?['likes']!.isEmpty
                  ? 'Like'
                  : msg.value?['likes'].length == 1
                      ? '1 Like'
                      : '${msg.value?['likes'].length} Likes',
              icon: msg.value?['likes'].contains(auth.uid) ?? true
                  ? Icons.thumb_up
                  : Icons.thumb_up_outlined,
              colour: msg.value?['likes'].contains(auth.uid) ?? true
                  ? ColourConfig.go
                  : null,
              onPressed: onLiked,
            ),
            me
                ? ReactionButton(
                    label: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: () async {
                      bool isConnected = await isOnline();
                      if (!isConnected) {
                        if (context.mounted) {
                          showSnackBar(context,
                              msg: "You're currently offline");
                        }
                        return;
                      }
                      if (context.mounted) {
                        messageEditDialogue(
                          context,
                          messageController: messageController,
                          onSaved: () {
                            if (widget.message.message ==
                                messageController.text.trim()) {
                              return;
                            }
                            MessageDB().edit(
                              context,
                              roomId: widget.room.id!,
                              wrkspcId: widget.wrkspcId,
                              messageId: widget.message.id!,
                              newMessage: messageController.text.trim(),
                            );
                          },
                        );
                      }
                    },
                  )
                : const SizedBox(),
            ReactionButton(
              label: me ? 'Delete' : 'Reply privately',
              icon: me ? Icons.delete_forever_outlined : Icons.reply,
              onPressed: me
                  ? () => deleteMessageAlertDialogue(
                        context,
                        msgId: widget.message.id!,
                        msgRef: widget.messageRef,
                      )
                  : () {
                      //! Do something for others
                    },
            ),
          ],
        ),
        height10,
        const Separator(height: 0),
      ],
    );
  }
}

class MsgTile extends StatelessWidget {
  const MsgTile({
    super.key,
    required this.widget,
    required this.firestore,
    required this.user,
    required this.msg,
    required this.date,
    required this.me,
  });

  final MessageDetailsScreen widget;
  final FirebaseFirestore firestore;
  final AsyncValue<Map<String, dynamic>?> user;
  final AsyncValue<Map<String, dynamic>?> msg;
  final String date;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ten),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: size / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            user.value?['image'],
                          ),
                        ),
                        SizedBox(width: ten),
                        Text(
                          me
                              ? '${user.value?['name']} (You)'
                              : user.value?['name'],
                          style: TextConfig.small,
                        ),
                      ],
                    ),
                    Text(date, style: TextConfig.intro)
                  ],
                ),
                height10,
                Visibility(
                  visible: widget.message.image != null &&
                      widget.message.image!.isNotEmpty,
                  child: widget.message.image != null &&
                          widget.message.image!.isNotEmpty
                      ? Column(
                          children: [
                            ClipRRect(
                              borderRadius: defaultBorderRadius,
                              child: CachedNetworkImage(
                                imageUrl: widget.message.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            height5,
                          ],
                        )
                      : const SizedBox(),
                ),
                height10,
                Text.rich(
                  TextSpan(
                    children: extractText(
                      context,
                      msg.value?['message'],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReactionButton extends StatelessWidget {
  const ReactionButton({
    super.key,
    required this.label,
    required this.icon,
    this.colour,
    this.onPressed,
  });
  final String label;
  final IconData icon;
  final Color? colour;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.all(ten),
          onPressed: onPressed,
          icon: Icon(icon, color: colour),
        ),
        Text(label, style: TextConfig.sub),
      ],
    );
  }
}
