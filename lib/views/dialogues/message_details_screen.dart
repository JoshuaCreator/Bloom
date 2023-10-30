import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../configs/consts.dart';
import '../../models/message.dart';
import 'loading_indicator.dart';
import '../widgets/message_tile.dart';

class MessageDetailsScreen extends StatelessWidget {
  const MessageDetailsScreen({
    super.key,
    required this.message,
    required this.repliesRef,
  });
  final Message message;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? repliesRef;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(message.time);
    const TextStyle textStyle = TextStyle(
      // fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
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
                    Text(message.sender, style: textStyle),
                    SizedBox(width: ten),
                    Text(time, style: textStyle),
                  ],
                ),
                height5,
                Text.rich(
                  TextSpan(children: extractText(context, message.message)),
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
              stream: repliesRef,
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
                    return ReplyTile(
                      text: data[index]['reply'],
                      sender: data[index]['sender'],
                      textStyle: textStyle,
                    );
                    // return ListTile(
                    //   title: ReadMoreText(
                    //     data[index]['reply'] * 20,
                    //     trimLength: 50,
                    //     moreStyle: textStyle,
                    //     lessStyle: textStyle,
                    //   ),
                    //   trailing: Text(data[index]['sender']),
                    //   titleAlignment: ListTileTitleAlignment.bottom,
                    // );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyTile extends StatelessWidget {
  const ReplyTile({
    super.key,
    required this.text,
    required this.sender,
    required this.textStyle,
  });

  final String text;
  final String sender;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ten),
      margin: EdgeInsets.only(bottom: ten),
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReadMoreText(
            text,
            moreStyle: const TextStyle(
              fontSize: 12.0,
              color: Colors.amber,
            ),
            lessStyle: const TextStyle(
              fontSize: 12.0,
              color: Colors.amber,
            ),
            trimMode: TrimMode.Line,
            trimLines: 3,
            trimExpandedText: '\t\tless',
            trimCollapsedText: 'more',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(sender, style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
