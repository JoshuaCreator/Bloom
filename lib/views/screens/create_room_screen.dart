import 'dart:io';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  static String id = 'create-room';
  const CreateRoomScreen({super.key, required this.deptId});
  final String deptId;

  @override
  ConsumerState<CreateRoomScreen> createState() =>
      _ConsumerCreateRoomScreenState();
}

class _ConsumerCreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  bool value = false;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    final auth = ref.watch(authStateProvider).value;
    final theme = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ten),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => imagePickerDialogue(
                    context,
                    onStorageTapped: () => _pickImage(ImageSource.gallery),
                    onCameraTapped: () => _pickImage(ImageSource.camera),
                  ),
                  child: image != null
                      ? CircleAvatar(
                          radius: size,
                          backgroundImage: FileImage(image!),
                        )
                      : CircleAvatar(
                          radius: size,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: theme == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                ),
                SizedBox(width: ten),
                Expanded(
                  child: AppTextField(
                    hintText: 'Room name (required)',
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    borderless: true,
                    autofocus: true,
                  ),
                ),
              ],
            ),
            height20,
            AppTextField(
              hintText: "Room description",
              maxLines: 5,
              controller: _descController,
              borderless: true,
            ),
            height20,
            PrivacySwitch(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
            height30,
            AppButton(
              label: 'Create',
              onTap: () {
                final Room room = Room(
                  name: _nameController.text.trim(),
                  desc: _descController.text.trim(),
                  creatorId: auth!.uid,
                  private: value,
                  createdAt: DateTime.now(),
                  participants: [auth.uid],
                );
                if (_nameController.text.trim().isEmpty) return;
                RoomDB().create(
                  room,
                  context,
                  deptId: widget.deptId,
                  userId: user?['id'],
                  image: image,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    context.pop();
    showLoadingIndicator(context);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      await _cropImage(image);
      if (context.mounted && image == null) context.pop();
    } on PlatformException catch (e) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: 'An error occurred: $e');
      }
    }
  }

  Future<void> _cropImage(XFile? image) async {
    final ImageCropper cropper = ImageCropper();
    if (image != null) {
      final CroppedFile? croppedImg =
          await cropper.cropImage(sourcePath: image.path, compressQuality: 10);
      final File temporaryImage = File(croppedImg!.path);
      setState(() {
        this.image = temporaryImage;
      });
      if (context.mounted) context.pop();
    }
  }
}

class PrivacySwitch extends StatelessWidget {
  const PrivacySwitch({super.key, required this.value, this.onChanged});
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Make this Room private?', style: TextStyle(fontSize: 16.0)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// Future<void> _uploadImage(
//   BuildContext context, {
//   required String roomName,
//   required File? image,
// }) async {
//   final path = 'rooms/$roomName/${image?.path}';
//   try {
//     final storageRef = FirebaseStorage.instance.ref().child(path);
//     final uploadTask = storageRef.putFile(image!);

//     final snapshot = await uploadTask.whenComplete(() {});
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//   } on FirebaseException catch (e) {
//     if (context.mounted) showSnackBar(context, msg: 'An error occurred: $e');
//   }
// }
