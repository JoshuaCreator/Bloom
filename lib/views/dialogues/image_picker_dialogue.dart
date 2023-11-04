import 'package:flutter/material.dart';

imagePickerDialogue(
  BuildContext context, {
  required void Function()? onStorageTapped,
  required void Function()? onCameraTapped,
}) {
  showModalBottomSheet(
    enableDrag: false,
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sd_storage_outlined),
            title: const Text('Device storage'),
            onTap: onStorageTapped,
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Camera'),
            onTap: onCameraTapped,
          ),
        ],
      );
    },
  );
}
