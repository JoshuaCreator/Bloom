import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/imports.dart';

class RoomTile extends ConsumerWidget {
  const RoomTile({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  final String id, name;
  final String? image, subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final image = ref.watch(roomImageProvider(id)).value;
    // final String img = image!['image'].toString().isEmpty
    //     ? 'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg'
    //     : image['image'] ??
    //         'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg';
    return ListTile(
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(
            image: image ??
                'https://images.pexels.com/photos/919278/pexels-photo-919278.jpeg',
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
      onLongPress: () {
        //! Show Bottom Sheet With Options
      },
      onTap: onTap,
    );
  }
}
