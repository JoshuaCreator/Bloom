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
    required this.wrkspcId,
  });
  final Message message;
  final CollectionReference<Map<String, dynamic>> messagesRef;
  final CollectionReference repliesRef;
  final void Function()? onTap;
  final String wrkspcId;

  @override
  ConsumerState<MessageTile> createState() => _ConsumerMessageTileState();
}

class _ConsumerMessageTileState extends ConsumerState<MessageTile> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.message.senderId));
    final replies = ref.watch(repliesCountProvider(widget.repliesRef));
    final repliesCount = replies.value?.length ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.message.isMe!
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: five, top: five, right: five, bottom: ten),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius:
                widget.message.isMe! ? myBorderRadius : yourBorderRadius,
            child: Container(
              padding: EdgeInsets.all(five),
              decoration: BoxDecoration(
                borderRadius:
                    widget.message.isMe! ? myBorderRadius : yourBorderRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: widget.message.isMe!
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImageViewer(
                        image: user.value?['image'] ?? '',
                        onInfoIconPressed: widget.message.isMe!
                            ? null
                            : () => context.push(
                                  '${WorkspaceScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.wrkspcId}/${RoomInfoScreen.id}/${widget.wrkspcId}/${UserScreen.id}/${widget.message.senderId}',
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
                  SizedBox(width: five),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: widget.message.isMe!
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: size * 3.5),
                            child: Text(
                              widget.message.isMe!
                                  ? ''
                                  : user.value?['name'] ?? '',
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
                          widget.message.isMe! && widget.message.pending!
                              ? Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.grey,
                                  size: size / 2.3,
                                )
                              : const SizedBox(),
                          SizedBox(width: ten),
                        ],
                      ),
                      height10,
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
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    alignment: widget.message.isMe!
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      widget.message.message.isEmpty
                          ? const SizedBox()
                          : ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: size * 7),
                              child: Text.rich(
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: extractText(
                                      context, widget.message.message),
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
                ],
              ),
            ),
          ),
        ),
      ],
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
