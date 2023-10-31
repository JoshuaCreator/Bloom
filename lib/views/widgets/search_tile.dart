import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });
  final String label;
  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ten),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ten),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: twenty,
            vertical: ten,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(ten),
          ),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: ten),
              Text(label, style: const TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
    );
  }
}
