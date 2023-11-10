import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/models/reply.dart';
import 'package:basic_board/views/widgets/seperator.dart';
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

class MessageDetailsScreen extends StatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.repliesRef,
  });
  final Message message;
  final CollectionReference repliesRef;

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
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
    String time = DateFormat('hh:mm a').format(widget.message.time);
    String date = DateFormat('dd MMM').format(widget.message.time);
    double bottom = MediaQuery.viewInsetsOf(context).bottom + forty + ten;
    return Scaffold(
      body: StreamBuilder(
        stream: repliesSnapshots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Oops! An error occurred"));
          }
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return const Center(child: Text('No replies yet'));
          }
          final data = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
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
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              const CircularProgressIndicator(),
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Text(
                                                      '❗Unable to load image❗'),
                                        ),
                                        height20,
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                            Row(
                              children: [
                                CircleAvatar(radius: size / 1.5),
                                SizedBox(width: ten),
                                Text(
                                  widget.message.senderName,
                                  style: TextConfig.small,
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
                ),
                const Seperator(height: 0),
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
                          sender: data[index]['replySenderName'],
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
            final user = ref.watch(userProvider);
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
                      replySenderName:
                          (user.value?['fName'] + ' ' + user.value?['lName'])
                              .toString()
                              .trim(),
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
