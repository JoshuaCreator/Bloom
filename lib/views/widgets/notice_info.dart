import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../configs/consts.dart';
import '../../models/message.dart';
import 'notice_tile.dart';

class NoticeInfo extends StatelessWidget {
  const NoticeInfo({super.key, required this.notice});
  final Message notice;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(notice.time);
    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(ten),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(ten),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visibility(
                  //   visible: true,
                  //   child: notice.image != null
                  //       ? Column(
                  //           children: [
                  //             Image.network(
                  //               notice.image!,
                  //               fit: BoxFit.cover,
                  //               loadingBuilder:
                  //                   (context, child, loadingProgress) =>
                  //                       const CircularProgressIndicator(),
                  //               errorBuilder: (context, error, stackTrace) =>
                  //                   const Text('❗Unable to load image❗'),
                  //             ),
                  //             height20,
                  //           ],
                  //         )
                  //       : const SizedBox(),
                  // ),
                  Row(
                    children: [
                      Text(
                        notice.sender,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: ten),
                      Text(time),
                    ],
                  ),
                  height5,
                  Text.rich(
                    TextSpan(children: extractText(context, notice.message)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
