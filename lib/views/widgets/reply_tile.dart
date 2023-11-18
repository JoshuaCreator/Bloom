import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configs/consts.dart';
import 'show_more_text.dart';

class ReplyTile extends ConsumerStatefulWidget {
  const ReplyTile({
    super.key,
    required this.text,
    required this.time,
    required this.replySenderId,
  });

  final String text, time, replySenderId;

  @override
  ConsumerState<ReplyTile> createState() => _ConsumerReplyTileState();
}

class _ConsumerReplyTileState extends ConsumerState<ReplyTile> {
  bool showReactions = false;
  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: five),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showReactions ? showReactions = false : showReactions = true;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(ten),
              margin: EdgeInsets.symmetric(horizontal: ten),
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.5),
                borderRadius: BorderRadius.circular(ten),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder(
                    future: firestore
                        .collection('users')
                        .doc(widget.replySenderId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: size / 2,
                            ),
                            SizedBox(width: ten),
                            Text('Some one', style: TextConfig.small),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Some one"));
                      }
                      final data = snapshot.data?.data();
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: size / 2,
                            backgroundImage: CachedNetworkImageProvider(
                              data?['image'],
                            ),
                          ),
                          SizedBox(width: ten),
                          Text(data?['name'], style: TextConfig.small),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: forty + ten),
                    child: AppShowMoreText(text: widget.text),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.time, style: TextConfig.small),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showReactions,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildReactionIconButton(
                    icon: Icons.favorite_border_outlined,
                    onPressed: () {},
                  ),
                  buildReactionIconButton(
                    icon: Icons.thumb_down_alt_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildReactionIconButton({
    required IconData icon,
    void Function()? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: size / 2,
      padding: EdgeInsets.zero,
      splashRadius: 1,
    );
  }
}
