import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../configs/consts.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({
    super.key,
    required this.text,
    required this.sender,
    required this.time,
    required this.textStyle,
  });

  final String text;
  final String sender;
  final String time;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sender, style: textStyle),
              Text(time, style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
