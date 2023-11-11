import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/models/reply.dart';
import 'package:basic_board/views/dialogues/app_dialogues.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../configs/consts.dart';
import '../../models/message.dart';
import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../services/date_time_formatter.dart';
import '../../services/message_db.dart';
import '../widgets/message_text_field.dart';
import '../widgets/reply_tile.dart';
import 'loading_indicator.dart';
import '../widgets/message_tile.dart';

class MessageDetailsScreen extends ConsumerStatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.repliesRef,
    required this.messageRef,
  });
  final Message message;
  final CollectionReference repliesRef;
  final CollectionReference messageRef;

  @override
  ConsumerState<MessageDetailsScreen> createState() =>
      _ConsumerMessageDetailsScreenState();
}

class _ConsumerMessageDetailsScreenState
    extends ConsumerState<MessageDetailsScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _replyTextController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>>? repliesSnapshots;

  @override
  void initState() {
    super.initState();
    repliesSnapshots = widget.repliesRef
        .orderBy('time', descending: true)
        .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>?;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider).value!;
    final firestore = ref.watch(firestoreProvider);

    String time = DateFormat('hh:mm a').format(widget.message.time);
    String date = DateFormat('dd MMM').format(widget.message.time);
    double bottom = MediaQuery.viewInsetsOf(context).bottom + forty + ten;
    return Scaffold(
      body: StreamBuilder(
        stream: repliesSnapshots,
        builder: (context, snapshot) {
          final bool me = auth.uid == widget.message.senderId;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Oops! An error occurred"));
          }
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return Column(
              children: [
                MsgTile(
                  widget: widget,
                  firestore: firestore,
                  date: date,
                  time: time,
                ),
                ReactionTile(me: me, widget: widget),
              ],
            );
          }
          final data = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: [
                MsgTile(
                  widget: widget,
                  firestore: firestore,
                  date: date,
                  time: time,
                ),
                ReactionTile(me: me, widget: widget),
                height10,
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: ten),
                      child: Text(
                        '${data.length} Replies',
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
                    return Column(
                      children: [
                        ReplyTile(
                          text: data[index]['reply'],
                          replySenderId: data[index]['replySenderId'],
                          time: timeAgo(timeStamp),
                        ),
                        // const Divider(height: 0),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: [
        Consumer(
          builder: (context, ref, child) {
            // final user = ref.watch(userProvider);
            final auth = ref.watch(authStateProvider).value;
            return Form(
              key: _key,
              child: MessageTextField(
                onSuffixPressed: () {
                  if (_replyTextController.text.trim().isEmpty) return;
                  MessageDB().reply(
                    ref: widget.repliesRef,
                    Reply(
                      message: _replyTextController.text.trim(),
                      replySenderId: auth!.uid,
                      toMessageId: widget.message.id!,
                      toSenderId: widget.message.senderId,
                      time: DateTime.now(),
                    ),
                    context,
                  );
                  _replyTextController.clear();
                },
                hintText: 'Type a reply',
                textController: _replyTextController,
                hasPrefix: false,
              ),
            );
          },
        ),
        SizedBox(height: bottom),
      ],
    );
  }
}

class ReactionTile extends StatelessWidget {
  const ReactionTile({super.key, required this.me, required this.widget});
  final bool me;
  final MessageDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Seperator(height: 0),
        height5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ReactionButton(
              label: 'Like',
              icon: Icons.thumb_up_outlined,
              onPressed: () {
                //! TODO Add Reaction
              },
            ),
            ReactionButton(
              label: me ? 'Edit' : 'Reply privately',
              icon: me ? Icons.edit_outlined : Icons.reply,
              onPressed: me
                  ? () {
                      //! Do something for me
                    }
                  : () {
                      //! Do something for others
                    },
            ),
            ReactionButton(
              label: me ? 'Delete' : 'Dislike',
              icon: me
                  ? Icons.delete_forever_outlined
                  : Icons.thumb_down_outlined,
              onPressed: me
                  ? () => deleteAlertDialogue(
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
        const Seperator(height: 0),
      ],
    );
  }
}

class MsgTile extends StatelessWidget {
  const MsgTile({
    super.key,
    required this.widget,
    required this.firestore,
    required this.date,
    required this.time,
  });

  final MessageDetailsScreen widget;
  final FirebaseFirestore firestore;
  final String date;
  final String time;

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
                Visibility(
                  visible: true,
                  child: widget.message.image != null
                      ? Column(
                          children: [
                            Image.network(
                              widget.message.image!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      const CircularProgressIndicator(),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Text('❗Unable to load image❗'),
                            ),
                            height20,
                          ],
                        )
                      : const SizedBox(),
                ),
                Row(
                  children: [
                    FutureBuilder(
                        future: firestore
                            .collection('users')
                            .doc(widget.message.senderId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircleAvatar(radius: size / 2),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Oops! An error occurred"));
                          }
                          final data = snapshot.data?.data();
                          return CircleAvatar(
                            radius: size / 2,
                            backgroundImage: CachedNetworkImageProvider(
                              data?['image'],
                            ),
                          );
                        }),
                    SizedBox(width: ten),
                    FutureBuilder(
                      future: firestore
                          .collection('users')
                          .doc(widget.message.senderId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text("Some one"),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text("Some one"));
                        }
                        final data = snapshot.data?.data();
                        return Text(
                          data?['name'],
                          style: TextConfig.intro,
                        );
                      },
                    ),
                  ],
                ),
                height10,
                Text.rich(
                  TextSpan(
                    children: extractText(
                      context,
                      widget.message.message,
                    ),
                  ),
                ),
                height10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$date $time',
                      style: TextConfig.small,
                    ),
                  ],
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
    this.onPressed,
  });
  final String label;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.all(ten),
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(label, style: TextConfig.sub),
      ],
    );
  }
}
