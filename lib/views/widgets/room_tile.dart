import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    required this.image,
    required this.name,
    required this.subtitle,
    required this.dateTime,
    required this.leading,
    this.onTap,
  });
  final String image;
  final String name;
  final String subtitle;
  final String dateTime;
  final IconData leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// Wrap [CircleAvatar] with [GestureDetector]
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => Container(
            // decoration: BoxDecoration(
            // shape: BoxShape.circle,
            //   image: DecorationImage(
            //     fit: BoxFit.cover,
            //     image: CachedNetworkImageProvider(image),
            //   ),
            // ),
            child: CircleAvatar(
              // maxRadius: size * 3,
              backgroundImage: CachedNetworkImageProvider(image),
            ),
          ),
        ),
        child: CircleAvatar(
          radius: circularAvatarRadius,
          // child: Icon(leading),
          backgroundImage: CachedNetworkImageProvider(image),
          onBackgroundImageError: (exception, stackTrace) => Icon(leading),
        ),
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16.0),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12.0),
      ),
      trailing: Text(dateTime),
      onLongPress: () {
        //! Show Bottom Sheet With Options
      },
      onTap: onTap,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ten)),
    );
  }
}
