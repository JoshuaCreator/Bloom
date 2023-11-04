import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/models/reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MessageDetailsScreen extends ConsumerWidget {
  MessageDetailsScreen({
    super.key,
    required this.message,
    required this.repliesSnapshots,
    required this.repliesRef,
  });
  final Message message;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? repliesSnapshots;
  final CollectionReference repliesRef;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider).value;

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
                  child: message.image != null
                      ? Column(
                          children: [
                            Image.network(
                              message.image!,
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
                    Text(message.senderName, style: TextConfig.small),
                    SizedBox(width: ten),
                    Text(timeAgo(message.time), style: TextConfig.small),
                  ],
                ),
                height5,
                Text.rich(
                  TextSpan(
                    children: extractText(context, message.message),
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
                child: Text(
                  'Replies',
                  style: TextConfig.intro,
                ),
              )
            ],
          ),
          height10,
          Flexible(
            child: StreamBuilder(
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

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    DateTime timeStamp = (data[index]['time']) == null
                        ? DateTime.now()
                        : (data[index]['time']).toDate();
                    return ReplyTile(
                      text: data[index]['reply'],
                      sender: data[index]['replySenderName'],
                      time: timeAgo(timeStamp),
                      textStyle: TextConfig.small,
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
                  ref: repliesRef,
                  Reply(
                    message: _replyTextController.text.trim(),
                    replySenderId: auth!.uid,
                    replySenderName:
                        (user.value?['fName'] + ' ' + user.value?['lName'])
                            .toString()
                            .trim(),
                    toMessageId: message.id!,
                    toSenderId: message.senderId,
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
