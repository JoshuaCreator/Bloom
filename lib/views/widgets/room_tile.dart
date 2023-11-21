import 'package:basic_board/views/screens/dept_screen.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/imports.dart';

class RoomTile extends ConsumerWidget {
  const RoomTile({
    super.key,
    required this.image,
    required this.name,
    this.subtitle,
    this.deptId,
    this.trailing,
    required this.roomData,
    this.showInfoIcon = false,
    this.onTap,
  });
  final String name;
  final String? image, subtitle, deptId;
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
            image: image ??
                'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
            onInfoIconPressed: showInfoIcon
                ? () => context.push(
                      '${DeptScreen.id}/${HomeScreen.id}/${RoomChatScreen.id}/${roomData.id}/${RoomInfoScreen.id}/$deptId',
                      extra: roomData,
                    )
                : null,
          ),
        ),
        child: CircleAvatar(
          radius: circularAvatarRadius,
          backgroundImage: CachedNetworkImageProvider(
            image ??
                'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
          ),
        ),
      ),
      title: Text(
        name,
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
