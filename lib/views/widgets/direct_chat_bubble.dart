import 'package:basic_board/models/direct_message.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';

/// This File is currently not in use. Until further notice
/// 
/// 
/// 
/// 

class ChatBubble extends ConsumerWidget {
  const ChatBubble({super.key, required this.directMsg});
  final DirectMsg directMsg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value!;
    final bool me = auth.uid == directMsg.fromId;
    return Row(
      mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ten),
          margin: EdgeInsets.all(ten),
          decoration: BoxDecoration(
            color: me ? ColourConfig.go : ColourConfig.danger,
            borderRadius: me
                ? BorderRadius.only(
                    topLeft: Radius.circular(twenty),
                    bottomLeft: Radius.circular(twenty),
                    topRight: Radius.circular(twenty),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(twenty),
                    bottomRight: Radius.circular(twenty),
                    topRight: Radius.circular(twenty),
                  ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size * 7),
            child: AppShowMoreText(text: directMsg.message, trimLines: 10),
          ),
        ),
      ],
    );
  }
}
