import 'package:basic_board/configs/consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_viewer.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.title,
    required this.image,
    this.trailing,
    this.onTap,
  });

  final String title, image;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => ImageViewer(image: image),
        ),
        child: Hero(
          tag: 'user-display-img',
          child: CircleAvatar(
            radius: circularAvatarRadius,
            backgroundImage: CachedNetworkImageProvider(image),
          ),
        ),
      ),
      title: Text(title),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ten,
        vertical: five,
      ),
      trailing: trailing,
    );
  }
}
