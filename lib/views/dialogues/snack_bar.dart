import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';

showSnackBar(BuildContext context, {required String msg}) {
  final SnackBar snackBar = SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
      // style: const TextStyle(color: Colors.white),
    ),
    shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    // backgroundColor: Colors.purple[200],
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
