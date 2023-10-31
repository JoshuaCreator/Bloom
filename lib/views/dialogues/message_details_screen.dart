import 'package:basic_board/models/reply.dart';
import 'package:basic_board/views/widgets/message_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../configs/consts.dart';
import '../../models/message.dart';
import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../services/message_db.dart';
import '../widgets/reply_tile.dart';
import 'loading_indicator.dart';
import '../widgets/message_tile.dart';

class MessageDetailsScreen extends ConsumerStatefulWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.repliesSnapshots,
    required this.repliesRef,
  });
  final Message message;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? repliesSnapshots;
  final CollectionReference repliesRef;

  @override
  ConsumerState<MessageDetailsScreen> createState() =>
      _ConsumerMessageDetailsScreenState();
}

class _ConsumerMessageDetailsScreenState
    extends ConsumerState<MessageDetailsScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _replyTextController = TextEditingController();

  TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider).value;
    String time = DateFormat('hh:mm a').format(widget.message.time);

    double bottom = MediaQuery.viewInsetsOf(context).bottom + forty + ten;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(ten),
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(0.1),
            ),
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
                    Text(widget.message.senderName, style: textStyle),
                    SizedBox(width: ten),
                    Text(time, style: textStyle),
                  ],
                ),
                height5,
                Text.rich(
                  TextSpan(
                    children: extractText(context, widget.message.message),
                  ),
                ),
              ],
            ),
          ),
          height30,
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: ten),
                child: const Text(
                  'Replies',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          height10,
          Flexible(
            child: StreamBuilder(
              stream: widget.repliesSnapshots,
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

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    DateTime timeStamp = (data[index]['time']) == null
                        ? DateTime.now()
                        : (data[index]['time']).toDate();
                    String time = DateFormat('EE, hh:mm a').format(timeStamp);
                    return ReplyTile(
                      text: data[index]['reply'],
                      sender: data[index]['replySenderName'],
                      time: time,
                      textStyle: textStyle,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Form(
          key: _key,
          child: Expanded(
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
          ),
        ),
        SizedBox(height: bottom),
      ],
    );
  }
}
