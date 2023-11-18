import '../../utils/imports.dart';

class MessageTile extends ConsumerStatefulWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.messageRef,
    this.onTap,
  });
  final Message message;
  final CollectionReference<Object?> messageRef;
  final void Function()? onTap;

  @override
  ConsumerState<MessageTile> createState() => _ConsumerMessageTileState();
}

class _ConsumerMessageTileState extends ConsumerState<MessageTile> {
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
    final firestore = ref.watch(firestoreProvider);
    return Padding(
      padding: EdgeInsets.only(left: five, top: five, right: five),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: defaultBorderRadius,
        child: Container(
          padding: EdgeInsets.all(five),
          decoration: BoxDecoration(borderRadius: defaultBorderRadius),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !widget.message.isMe!
                  ? const SizedBox()
                  : FutureBuilder(
                      future: firestore
                          .collection('users')
                          .doc(widget.message.senderId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircleAvatar(radius: size / 2),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: CircleAvatar(radius: size / 2));
                        }
                        // if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
                        //   return const Center(child: Text('No replies yet'));
                        // }
                        final data = snapshot.data?.data();
                        return CircleAvatar(
                          radius: size / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            data?['image'],
                          ),
                        );
                      }),
              !widget.message.isMe! ? const SizedBox() : SizedBox(width: ten),
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
                        FutureBuilder(
                          future: firestore
                              .collection('users')
                              .doc(widget.message.senderId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text("Some one"),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text("Some one"));
                            }
                            final data = snapshot.data?.data();
                            return Text(
                              data?['name'],
                              style: TextConfig.intro,
                            );
                          },
                        ),
                        !widget.message.isMe!
                            ? const SizedBox()
                            : SizedBox(width: ten),
                        Text(
                          timeAgo(widget.message.time),
                          style: TextConfig.intro,
                        ),
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
                        style: TextConfig.sub,
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
