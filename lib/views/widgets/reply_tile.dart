import 'package:basic_board/configs/text_config.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../configs/consts.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({
    super.key,
    required this.text,
    required this.sender,
    required this.time,
  });

  final String text;
  final String sender;
  final String time;

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(radius: size / 1.5),
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
          height10,
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
