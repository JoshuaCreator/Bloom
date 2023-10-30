import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../configs/consts.dart';

class AppButton extends ConsumerWidget {
  const AppButton({super.key, required this.title, this.onTap});
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      splashColor: Colors.purple.shade50.withOpacity(0.5),
      highlightColor: Colors.purple.shade50.withOpacity(0.5),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onTap,
      child: Container(
        // width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: thirty, vertical: ten),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.purple.withOpacity(0.5),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
