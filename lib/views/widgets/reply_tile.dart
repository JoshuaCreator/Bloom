import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

import '../../configs/consts.dart';

class ReplyTile extends ConsumerWidget {
  const ReplyTile(
      {super.key,
      required this.text,
      required this.sender,
      required this.time,
      required this.replySenderId});

  final String text, sender, time, replySenderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestore = ref.watch(firestoreProvider);
    return Container(
      padding: EdgeInsets.all(ten),
      margin: EdgeInsets.symmetric(horizontal: ten, vertical: five),
      decoration: BoxDecoration(
        color: Colors.grey.shade300.withOpacity(0.5),
        borderRadius: defaultBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              FutureBuilder(
                  future:
                      firestore.collection('users').doc(replySenderId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircleAvatar(radius: size / 1.5),
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
              Text(sender, style: TextConfig.small),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: forty + ten),
            child: ReadMoreText(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(time, style: TextConfig.small),
            ],
          ),
        ],
      ),
    );
  }
}
