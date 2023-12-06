import 'dart:io';

import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/space_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/widgets/privacy_tile.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class CreateSpaceScreen extends ConsumerStatefulWidget {
  static String id = 'create-space';
  const CreateSpaceScreen({super.key});

  @override
  ConsumerState<CreateSpaceScreen> createState() =>
      _ConsumerCreateSpaceScreenState();
}

class _ConsumerCreateSpaceScreenState extends ConsumerState<CreateSpaceScreen> {
  bool value = false;

  String privacyText = 'Public (Anyone can join)';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _descController = TextEditingController();

  bool visible = true;

  final ImageHelper imageHelper = ImageHelper();

  File? image;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final auth = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Space")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Visibility(
                visible: visible,
                child: Padding(
                  padding: EdgeInsets.all(ten),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => imagePickerDialogue(
                              context,
                              onStorageTapped: () => imageHelper
                                  .pickImage(context,
                                      source: ImageSource.gallery)
                                  .then((value) => imageHelper
                                      .cropImage(context, path: value))
                                  .then((value) {
                                setState(
                                  () => image = File(value),
                                );
                                context.pop();
                                context.pop();
                              }),
                              onCameraTapped: () => imageHelper
                                  .pickImage(context,
                                      source: ImageSource.camera)
                                  .then((value) => imageHelper
                                      .cropImage(context, path: value))
                                  .then((value) {
                                setState(
                                  () => image = File(value),
                                );
                                context.pop();
                                context.pop();
                              }),
                            ),
                            child: Container(
                              width: size * 2,
                              height: size * 2,
                              decoration: BoxDecoration(
                                color: ColourConfig.grey,
                                borderRadius: defaultBorderRadius,
                                image: image == null
                                    ? null
                                    : DecorationImage(
                                        image: FileImage(image!),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: image == null
                                  ? Center(
                                      child: Icon(
                                      Icons.image,
                                      size: size,
                                    ))
                                  : null,
                            ),
                          ),
                          SizedBox(width: ten),
                          Expanded(
                            child: AppTextField(
                              hintText: 'Name (required)',
                              textInputAction: TextInputAction.next,
                              controller: _nameController,
                              autofocus: true,
                              borderless: true,
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
                        validate: false,
                      ),
                      height30,
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
                        onTap: () async {
                          final isConnected = await isOnline();
                          if (!isConnected) {
                            if (context.mounted) {
                              showSnackBar(context, msg: "You're offline");
                            }
                            return;
                          }
                          if (_nameController.text.trim().isEmpty) {
                            if (context.mounted) {
                              showSnackBar(context,
                                  msg: 'The name field is required');
                            }
                            return;
                          }
                          final Space space = Space(
                            id: 'id',
                            name: _nameController.text.trim(),
                            desc: _descController.text.trim(),
                            participants: [auth.value?.uid],
                            creatorId: user!.uid,
                            createdAt: DateTime.now(),
                            private: value,
                          );
                          if (context.mounted) {
                            SpaceDB().create(
                              context,
                              space: space,
                              userId: user.uid,
                              imagePath: image?.path ?? '',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
