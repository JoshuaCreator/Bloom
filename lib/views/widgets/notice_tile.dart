// import 'package:flutter/gestures.dart';
import 'package:basic_board/views/widgets/app_dialogues.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/models/message.dart';
import 'package:intl/intl.dart';
import 'package:basic_board/views/widgets/notice_info.dart';

class NoticeTile extends StatelessWidget {
  const NoticeTile({super.key, required this.notice});
  final Message notice;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(notice.time);
    return Padding(
      padding: EdgeInsets.only(top: ten),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => NoticeInfo(notice: notice),
          );
        },
        child: Container(
          padding: EdgeInsets.all(ten),
          decoration: const BoxDecoration(
              // color: Colors.grey.shade100.withOpacity(0.1),
              ),
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
              //               loadingBuilder: (context, child, loadingProgress) =>
              //                   const CircularProgressIndicator(),
              //               errorBuilder: (context, error, stackTrace) =>
              //                   const Text('Unable to load image'),
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
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                TextSpan(children: extractText(context, notice.message)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<TextSpan> extractText(BuildContext context, String rawString) {
  List<TextSpan> textSpan = [];

  final urlRegExp = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?",
  );

  getLink(String linkString) {
    Uri link = Uri.parse(linkString);
    textSpan.add(
      TextSpan(
        text: linkString,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => linkAlertDialogue(
                context,
                link: link,
                linkString: linkString,
              ),
        // onEnter: (event) => bgroundColour = Colors.red,
        // onExit: (event) => bgroundColour = Colors.transparent,
      ),
    );
    return linkString;
  }

  getNormalText(String normalText) {
    textSpan.add(TextSpan(text: normalText));
    return normalText;
  }

  rawString.splitMapJoin(
    urlRegExp,
    onMatch: (match) => getLink("${match.group(0)}"),
    onNonMatch: (nonMatch) => getNormalText(nonMatch.substring(0)),
  );
  return textSpan;
}
