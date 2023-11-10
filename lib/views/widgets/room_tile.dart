import 'package:basic_board/configs/colour_config.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    required this.image,
    required this.name,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });
  final String image;
  final String name;
  final String subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return ListTile(
      leading: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(twenty),
              decoration: BoxDecoration(
                color: ColourConfig.backgroundColour(brightness),
                borderRadius: BorderRadius.circular(forty),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: size * 4,
                    backgroundImage: CachedNetworkImageProvider(image),
                  ),
                  height20,
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: twenty,
                      color: ColourConfig.foregroundColour(brightness),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      subtitle: Text(
        subtitle,
        maxLines: 2,
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
