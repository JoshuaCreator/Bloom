import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/app_circle_avatar.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';

class UserScreen extends ConsumerWidget {
  static String id = 'user-screen';
  const UserScreen({super.key, required this.userId, required this.tag});
  final String userId, tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(anyUserProvider(userId));
    final userImg = user.value?['image'] ?? '';
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => ImageViewer(image: userImg),
            ),
            child: Hero(
              tag: tag,
              child: AppCircleAvatar(
                image: CachedNetworkImageProvider(userImg),
                userId: user.value?['id'] ?? '',
              ),
            ),
          ),
          height10,
          Text(
            user.value?['name'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size / 1.3),
          ),
          const Separator(),
          AppShowMoreText(text: user.value?['about'] ?? ''),
          user.value?['about'] == null || user.value?['about']!.isEmpty
              ? const SizedBox()
              : const Separator(),
        ],
      ),
    );
  }
}
