import 'dart:io';
import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';
import 'package:basic_board/views/widgets/privacy_tile.dart';
import 'package:image_picker/image_picker.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  static String id = 'create-room';
  const CreateRoomScreen({super.key, required this.wrkspcId});
  final String wrkspcId;

  @override
  ConsumerState<CreateRoomScreen> createState() =>
      _ConsumerCreateRoomScreenState();
}

class _ConsumerCreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  bool value = false;
  String privacyText = 'Public (Anyone can join)';
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  File? image;
  final ImageHelper imageHelper = ImageHelper();

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
                    onStorageTapped: () => imageHelper
                        .pickImage(context, source: ImageSource.gallery)
                        .then((value) =>
                            imageHelper.cropImage(context, path: value))
                        .then((value) {
                      setState(
                        () => image = File(value),
                      );
                      context.pop();
                      context.pop();
                    }),
                    onCameraTapped: () => imageHelper
                        .pickImage(context, source: ImageSource.camera)
                        .then((value) =>
                            imageHelper.cropImage(context, path: value))
                        .then((value) {
                      setState(
                        () => image = File(value),
                      );
                      context.pop();
                      context.pop();
                    }),
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
                    hintText: 'Name (required)',
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
              hintText: "Description",
              maxLines: 5,
              controller: _descController,
              borderless: true,
            ),
            height20,
            PrivacySwitch(
              value: value,
              text: privacyText,
              onChanged: (newValue) {
                if (value) {
                  setState(() {
                    value = false;
                    privacyText = 'Public (Anyone can join)';
                  });
                } else {
                  setState(() {
                    value = true;
                    privacyText = 'Private (Invite only)';
                  });
                }
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
                if (_nameController.text.trim().isEmpty) {
                  showSnackBar(context, msg: 'The name field is required');
                  return;
                }
                RoomDB().create(
                  room,
                  context,
                  wrkspcId: widget.wrkspcId,
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
}
