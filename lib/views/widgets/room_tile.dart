import 'package:basic_board/views/widgets/image_viewer.dart';
import '../../utils/imports.dart';

class RoomTile extends ConsumerWidget {
  const RoomTile({
    super.key,
    this.subtitle,
    this.wrkspcId,
    this.trailing,
    required this.roomData,
    this.showInfoIcon = false,
    this.onTap,
  });
  final String? subtitle, wrkspcId;
  final Widget? trailing;
  final Room roomData;
  final bool showInfoIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(
            image: roomData.image!,
            onInfoIconPressed: showInfoIcon
                ? () => context.push(
                      '${WorkspaceScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${roomData.id}/${RoomInfoScreen.id}/$wrkspcId',
                      extra: roomData,
                    )
                : null,
          ),
        ),
        child: CircleAvatar(
          radius: circularAvatarRadius,
          backgroundImage: CachedNetworkImageProvider(
            roomData.image!,
          ),
        ),
      ),
      title: Text(
        roomData.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16.0),
      ),
      subtitle: subtitle == null || subtitle!.isEmpty
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.0),
            ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
