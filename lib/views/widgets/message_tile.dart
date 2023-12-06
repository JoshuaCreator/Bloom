import 'package:basic_board/providers/room/message_data_providers.dart';
import 'package:basic_board/providers/users_providers.dart';

import '../../utils/imports.dart';
import '../screens/user_screen.dart';
import 'image_viewer.dart';

class MessageTile extends ConsumerStatefulWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.messagesRef,
    required this.repliesRef,
    this.onTap,
    required this.spaceId,
  });
  final Message message;
  final CollectionReference<Map<String, dynamic>> messagesRef;
  final CollectionReference repliesRef;
  final void Function()? onTap;
  final String spaceId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageTileState();
}

class _MessageTileState extends ConsumerState<MessageTile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.message.senderId));
    final replies = ref.watch(repliesCountProvider(widget.repliesRef));
    final repliesCount = replies.value?.length ?? 0;

    return Padding(
      padding: EdgeInsets.all(five),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: EdgeInsets.all(ten),
          child: Column(
            crossAxisAlignment: widget.message.me!
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                textDirection:
                    widget.message.me! ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewer(
                        image: user.value?['image'] ?? '',
                        onInfoIconPressed: widget.message.me!
                            ? null
                            : () => context.push(
                                  '${SpaceScreen.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${widget.spaceId}/${RoomInfoScreen.id}/${widget.spaceId}/${UserScreen.id}/${widget.message.senderId}',
                                ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: size / 2,
                      backgroundImage: CachedNetworkImageProvider(
                        user.value?['image'] ?? '',
                      ),
                    ),
                  ),
                  SizedBox(width: ten),
                  Container(
                    constraints: BoxConstraints(maxWidth: size * 3.5),
                    child: Text(
                      widget.message.me! ? '' : user.value?['name'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextConfig.intro,
                    ),
                  ),
                  SizedBox(width: ten),
                  Text(
                    timeAgo(widget.message.time),
                    style: TextConfig.intro.copyWith(fontSize: ten),
                  ),
                  SizedBox(width: ten),
                  widget.message.me! && widget.message.pending!
                      ? Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                          size: size / 2.3,
                        )
                      : const SizedBox(),
                  SizedBox(width: ten),
                ],
              ),

              Visibility(
                visible: widget.message.image != null &&
                    widget.message.image!.isNotEmpty,
                child: widget.message.image != null &&
                        widget.message.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: defaultBorderRadius,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: size * 4,
                            maxWidth: size * 6,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.image!.isEmpty ||
                                    widget.message.image == null
                                ? defaultRoomImg
                                : widget.message.image!,
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: size * 3,
                            ),
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                            alignment: widget.message.me!
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),

              /// If the user only sends a file with no text, a SizedBox()
              /// takes the place of the text 👇🏽

              widget.message.message.isEmpty
                  ? const SizedBox()
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: size * 9),
                      child: Text.rich(
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children:
                              extractText(context, widget.message.message),
                        ),
                      ),
                    ),
              height5,
              Visibility(
                visible: repliesCount > 0,
                child: Text(
                  'Replies ($repliesCount)',
                  style: TextConfig.sub,
                ),
              )
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
