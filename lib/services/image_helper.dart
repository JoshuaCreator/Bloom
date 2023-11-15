// import 'dart:io';

// import 'package:basic_board/utils/imports.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import '../views/dialogues/loading_indicator_build.dart';

// class ImageHelper {
//   File? image;
//   Future<void> _pickImage(
//     BuildContext context, {
//     required ImageSource source,
//     required File image,
//     required void Function(void Function() fn) setState,
//   }) async {
//     context.pop();
//     showLoadingIndicator(context);
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: source);
//       if (context.mounted) {
//         await ImageHelper()._cropImage(
//           context,
//           image: image,
//           setState: setState,
//         );
//       }
//       if (context.mounted && image == null) context.pop();
//     } on PlatformException catch (e) {
//       if (context.mounted) {
//         context.pop();
//         showSnackBar(context, msg: 'An error occurred: $e');
//       }
//     }
//   }

//   Future<void> _cropImage(
//     BuildContext context, {
//     required XFile? image,
//     required void Function(void Function() fn) setState,
//   }) async {
//     final ImageCropper cropper = ImageCropper();
//     if (image != null) {
//       final CroppedFile? croppedImg =
//           await cropper.cropImage(sourcePath: image.path, compressQuality: 10);
//       final File temporaryImage = File(croppedImg!.path);
//       setState(() {
//         this.image = temporaryImage;
//       });
//       if (context.mounted) context.pop();
//     }
//   }
// }
