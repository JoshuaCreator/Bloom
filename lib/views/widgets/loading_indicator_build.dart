import 'package:basic_board/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const LoadingIndicator(isBuild: true);
    },
  );
}
