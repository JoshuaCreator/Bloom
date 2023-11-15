import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    required this.image,
    required this.name,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  final String image, name;
  final String? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(image: image, name: name),
        ),
        child: CircleAvatar(
          radius: circularAvatarRadius,
          // child: Icon(leading),
          backgroundImage: CachedNetworkImageProvider(image),
          onBackgroundImageError: (exception, stackTrace) =>
              const Icon(Icons.group_outlined),
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
      onLongPress: () {
        //! Show Bottom Sheet With Options
      },
      onTap: onTap,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ten)),
    );
  }
}
