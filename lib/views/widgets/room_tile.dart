import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';

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
      isThreeLine: true,
      leading: CircleAvatar(
        radius: size / 1.5,
        // child: Icon(leading),
        backgroundImage: NetworkImage(image),
        onBackgroundImageError: (exception, stackTrace) => Icon(leading),
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
