import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.trailing,
    this.onTap,
  });
  final String title, subtitle;
  final IconData leading;
  final Icon? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leading,
        size: 28,
        color: Colors.grey,
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
