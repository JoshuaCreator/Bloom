import 'package:basic_board/views/widgets/b_nav_bar.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import '../../utils/imports.dart';

class RoomTile extends ConsumerWidget {
  const RoomTile({
    super.key,
    this.subtitle,
    this.spaceId,
    this.trailing,
    required this.roomData,
    this.showInfoIcon = false,
    this.onTap,
  });
  final String? subtitle, spaceId;
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
            image: roomData.image!.isEmpty || roomData.image == null
                ? defaultRoomImg
                : roomData.image!,
            onInfoIconPressed: showInfoIcon
                ? () => context.push(
                      '${BNavBar.id}/${RoomChatsScreen.id}/${RoomMsgScreen.id}/${roomData.id}/${RoomInfoScreen.id}/$spaceId',
                      extra: roomData,
                    )
                : null,
          ),
        ),
        child: CircleAvatar(
          radius: circularAvatarRadius,
          backgroundImage: CachedNetworkImageProvider(
            roomData.image!.isEmpty || roomData.image == null
                ? defaultRoomImg
                : roomData.image!,
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
