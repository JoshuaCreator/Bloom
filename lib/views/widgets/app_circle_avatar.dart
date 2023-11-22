import '../../utils/imports.dart';

class AppCircleAvatar extends ConsumerWidget {
  const AppCircleAvatar({
    super.key,
    required this.image,
    required this.userId,
  });

  final ImageProvider<Object>? image;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(anyUserProvider(userId));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ten),
      constraints: BoxConstraints(
        maxHeight: size * 7,
        minHeight: size * 5,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: five,
          color: user.value?['active'] == true
              ? ColourConfig.go
              : ColourConfig.danger,
        ),
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.contain),
        shape: BoxShape.circle,
      ),
    );
  }
}
