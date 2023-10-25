import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class RoomTile extends StatelessWidget {
  const RoomTile({
    super.key,
    required this.selected,
    required this.name,
    required this.leading,
    this.onTap,
  });
  final bool selected;
  final String name;
  final IconData leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(leading)),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16.0),
      ),
      onLongPress: () {
        //! Show Bottom Sheet With Options
      },
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ten)),
    );
  }
}
