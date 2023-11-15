import 'package:basic_board/views/dialogues/loading_indicator.dart';
import 'package:flutter/material.dart';

showLoadingIndicator(BuildContext context, {String label = 'Loading...'}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return LoadingIndicator(isBuild: true, label: label);
    },
  );
}
