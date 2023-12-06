import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';

showSnackBar(BuildContext context, {required String msg}) {
  final SnackBar snackBar = SnackBar(
    content: Text(msg, textAlign: TextAlign.center),
    shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    behavior: SnackBarBehavior.fixed,
    showCloseIcon: true,
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
