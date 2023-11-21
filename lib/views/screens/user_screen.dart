import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:basic_board/views/widgets/show_more_text.dart';

class UserScreen extends ConsumerWidget {
  static String id = 'user-screen';
  const UserScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(anyUserProvider(userId));
    final userImg = user.value?['image'];
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => ImageViewer(image: userImg),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: ten),
              // height: size * 7,
              constraints: BoxConstraints(
                maxHeight: size * 7,
                minHeight: size * 5,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: five,
                  color: ColourConfig.go,
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(userImg),
                  fit: BoxFit.contain,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          height10,
          Text(
            user.value?['name'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size / 1.3),
          ),
          const Separator(),
          AppShowMoreText(text: user.value?['about']),
          const Separator(),
          // Padding(
          //   padding: EdgeInsets.only(left: ten),
          //   child: Text('Contact', style: TextConfig.intro),
          // ),
          // height5,
          // Text('0${user.value?['phone']}'),
          // Text(user.value?['email']),
          // const Separator(),
        ],
      ),
    );
  }
}
