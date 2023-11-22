import 'dart:io';

import 'package:basic_board/views/dialogues/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileHelper {
  Future<String> pickFile(BuildContext context) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return '';
    File file = File(result.files.single.path!);
    return file.path;
  }

  Future<String> uploadFile(
    BuildContext context, {
    required String filePath,
    required DocumentReference docRef,
    required String storagePath,
  }) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final uploadTask =
        await storage.ref().child(storagePath).putFile(File(filePath));
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    await docRef.update({'file': downloadUrl}).then((_) {
      if (context.mounted) {
        showSnackBar(context, msg: 'File uploaded');
      }
    });
    return downloadUrl;
  }
}
