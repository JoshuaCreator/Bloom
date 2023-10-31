import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class AppPopupMenu extends StatelessWidget {
  const AppPopupMenu({super.key, required this.items});
  final List<PopupMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      offset: const Offset(0, kToolbarHeight),
      itemBuilder: (context) => items,
    );
  }

  static PopupMenuItem buildPopupMenuItem(
    BuildContext context, {
    required String label,
    required void Function()? onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
