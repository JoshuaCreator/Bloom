import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/screens/user_screen.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'show_more_text.dart';

class ReplyTile extends ConsumerStatefulWidget {
  const ReplyTile({
    super.key,
    required this.reply,
    required this.replyRef,
    required this.deptId,
  });

  final Reply reply;
  final DocumentReference replyRef;
  final String deptId;

  @override
  ConsumerState<ReplyTile> createState() => _ConsumerReplyTileState();
}

class _ConsumerReplyTileState extends ConsumerState<ReplyTile> {
  bool showReactions = false;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(anyUserProvider(widget.reply.replySenderId));
    final auth = ref.watch(authStateProvider).value!;
    final textController = TextEditingController(text: widget.reply.message);
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ImageViewer(
                            image: user.value?['image'],
                            onInfoIconPressed: widget.reply.isMe!
                                ? null
                                : () => context.push(
                                      '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${widget.deptId}/${RoomInfoScreen.id}/${widget.deptId}/${UserScreen.id}/${widget.reply.replySenderId}',
                                    ),
                          ),
                        ),
                        child: CircleAvatar(
                          radius: size / 2,
                          backgroundImage: CachedNetworkImageProvider(
                            user.value?['image'],
                          ),
                        ),
                      ),
                      SizedBox(width: ten),
                      Text(
                        widget.reply.isMe!
                            ? '${user.value?['name']} (You)'
                            : user.value?['name'],
                        style: TextConfig.small,
                      ),
                      widget.reply.pending!
                          ? Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                              size: size / 2.3,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: forty + ten),
                    child: AppShowMoreText(text: widget.reply.message),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.reply.likes!.isEmpty
                            ? ''
                            : widget.reply.likes?.length == 1
                                ? '1 like'
                                : '${widget.reply.likes?.length} likes',
                        style: TextConfig.small,
                      ),
                      Text(timeAgo(widget.reply.time), style: TextConfig.small),
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
                    icon: widget.reply.likes!.contains(auth.uid)
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: widget.reply.likes!.contains(auth.uid)
                        ? ColourConfig.danger
                        : null,
                    tooltip: widget.reply.likes!.contains(auth.uid)
                        ? 'Revoke like'
                        : 'Like',
                    onPressed: () {
                      widget.reply.likes!.contains(auth.uid)
                          ? setState(() {
                              widget.replyRef.update({
                                'likes': FieldValue.arrayRemove([auth.uid])
                              });
                            })
                          : setState(
                              () {
                                widget.replyRef.update({
                                  'likes': FieldValue.arrayUnion([auth.uid])
                                });
                              },
                            );
                    },
                  ),
                  widget.reply.isMe!
                      ? buildReactionIconButton(
                          icon: Icons.delete_outline,
                          tooltip: 'Delete reply',
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text('Delete reply?'),
                              actions: [
                                AppTextButton(
                                  label: 'Delete',
                                  onPressed: () => widget.replyRef
                                      .delete()
                                      .then((value) => context.pop()),
                                ),
                                AppTextButton(
                                  label: 'Cancel',
                                  onPressed: () => context.pop(),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  widget.reply.isMe!
                      ? buildReactionIconButton(
                          icon: Icons.edit_outlined,
                          tooltip: 'Edit reply',
                          onPressed: () => messageEditDialogue(
                            context,
                            messageController: textController,
                            onSaved: () {
                              if (widget.reply.message ==
                                  textController.text.trim()) {
                                return;
                              }
                              showLoadingIndicator(context, label: 'Saving...');
                              widget.replyRef.update(
                                  {'reply': textController.text.trim()}).then(
                                (value) {
                                  context.pop();
                                  context.pop();
                                  showSnackBar(context, msg: 'Reply edited');
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
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
    Color? color,
    required String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: size / 2,
      padding: EdgeInsets.zero,
      splashRadius: 1,
      color: color,
      tooltip: tooltip,
    );
  }
}
