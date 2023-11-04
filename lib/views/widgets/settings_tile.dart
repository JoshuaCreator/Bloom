import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    // required this.subtitle,
    required this.leading,
    // this.trailing,
    this.onTap,
  });
  final String title; //subtitle;
  final IconData leading;
  // final Icon? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading, color: Colors.grey),
      title: Text(title),
      // subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      // trailing: trailing,
      onTap: onTap,
    );
  }
}
