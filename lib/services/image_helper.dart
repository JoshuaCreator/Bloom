import 'dart:io';

import 'package:basic_board/utils/imports.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../views/dialogues/loading_indicator_build.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHelper {
  Future<String> pickImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    final ImagePicker picker = ImagePicker();
    showLoadingIndicator(context);
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      return image.path;
    } else {
      if (context.mounted) {
        context.pop();
        context.pop();
      }
      return '';
    }
  }

  Future<String> cropImage(
    BuildContext context, {
    required String path,
  }) async {
    final ImageCropper cropper = ImageCropper();
    final CroppedFile? croppedImg = await cropper.cropImage(sourcePath: path);

    return croppedImg!.path;
  }

  Future<String> uploadImage(
    BuildContext context, {
    required String imagePath,
    required DocumentReference docRef,
    required String storagePath,
    String? msg,
  }) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final uploadTask =
        await storage.ref().child(storagePath).putFile(File(imagePath));
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    await docRef.update({'image': downloadUrl}).then((_) {
      // context.pop();
      if (context.mounted) {
        showSnackBar(context, msg: msg ?? 'Image uploaded');
      }
    });
    return downloadUrl;
  }
}
