import 'package:basic_board/views/dialogues/app_dialogues.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/models/message.dart';
import 'package:intl/intl.dart';
import 'package:basic_board/views/dialogues/message_details_screen.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.messageRef,
  });
  final Message message;
  final CollectionReference<Object?> messageRef;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  late int numberOfReplies = 0;

  @override
  void initState() {
    super.initState();
    widget.messageRef
        .doc(widget.message.id)
        .collection('replies')
        .count()
        .get()
        .then((value) => setState(() => numberOfReplies = value.count));
  }

  @override
  Widget build(BuildContext context) {
    final repliesRef = widget.messageRef
        .doc(widget.message.id)
        .collection('replies')
        .snapshots();

    String time = DateFormat('hh:mm a').format(widget.message.time);
    const TextStyle textStyle = TextStyle(
      // fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
    return Padding(
      padding: EdgeInsets.only(left: ten, top: five, right: ten),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            // anchorPoint: Offset(0, kBottomNavigationBarHeight),
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (context) => MessageDetailsScreen(
              message: widget.message,
              repliesRef: repliesRef,
            ),
          );
        },
        borderRadius: defaultBorderRadius,
        child: Container(
          padding: EdgeInsets.only(
            left: ten,
            top: five,
            right: ten,
            bottom: five,
          ),
          decoration: BoxDecoration(borderRadius: defaultBorderRadius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.message.isMe!
                  ? const SizedBox()
                  : CircleAvatar(radius: size / 3),
              widget.message.isMe! ? const SizedBox() : SizedBox(width: ten),
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
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          const CircularProgressIndicator(),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Unable to load image'),
                                ),
                                height20,
                              ],
                            )
                          : const SizedBox(),
                    ),
                    Row(
                      children: [
                        Text(
                          !widget.message.isMe! ? '' : widget.message.sender,
                          style: textStyle,
                        ),
                        !widget.message.isMe!
                            ? const SizedBox()
                            : SizedBox(width: ten),
                        Text(time, style: textStyle),
                        SizedBox(width: ten),
                        widget.message.pending!
                            ? Icon(
                                Icons.access_time_rounded,
                                color: Colors.grey,
                                size: size / 2.3,
                              )
                            : Icon(
                                Icons.done_rounded,
                                color: Colors.green,
                                size: size / 2.3,
                              ),
                      ],
                    ),
                    height5,
                    Text.rich(
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: extractText(context, widget.message.message),
                      ),
                    ),
                    height5,
                    Visibility(
                      visible: numberOfReplies > 0,
                      child: Text(
                        numberOfReplies == 1
                            ? '1 reply'
                            : '$numberOfReplies replies',
                        style: TextStyle(
                          fontSize: 12.0,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  ],
                ),
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
          // fontWeight: FontWeight.w500,
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
