import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.hintText,
    required this.textController,
    this.hasPrefix = true,
    this.onPrefixPressed,
    this.onSend,
  });
  final String hintText;
  final TextEditingController textController;
  final bool hasPrefix;
  final void Function()? onPrefixPressed;
  final void Function()? onSend;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        prefixIcon: hasPrefix
            ? IconButton(
                onPressed: onPrefixPressed,
                icon: const Icon(Icons.attach_file_rounded),
                tooltip: 'Attach file',
              )
            : null,
        suffixIcon: IconButton(
          onPressed: onSend,
          icon: const Icon(Icons.send_rounded),
          tooltip: 'Send',
        ),
        contentPadding: EdgeInsets.only(
          left: hasPrefix ? 0.0 : twenty,
          right: ten,
          top: five,
          bottom: five,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.3),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      controller: textController,
    );
  }
}
