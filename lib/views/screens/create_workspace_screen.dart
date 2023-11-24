import 'dart:io';

import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/workspace_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class CreateWorkspaceScreen extends ConsumerStatefulWidget {
  static String id = 'create-workspace';
  const CreateWorkspaceScreen({super.key});

  @override
  ConsumerState<CreateWorkspaceScreen> createState() =>
      _ConsumerCreateWorkspaceScreenState();
}

class _ConsumerCreateWorkspaceScreenState
    extends ConsumerState<CreateWorkspaceScreen> {
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
      appBar: AppBar(title: const Text("Create Workspace")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () => imagePickerDialogue(
            //     context,
            //     onStorageTapped: () => imageHelper
            //         .pickImage(context, source: ImageSource.gallery)
            //         .then(
            //             (value) => imageHelper.cropImage(context, path: value))
            //         .then((value) {
            //       setState(
            //         () => image = File(value),
            //       );
            //       context.pop();
            //       context.pop();
            //     }),
            //     onCameraTapped: () => imageHelper
            //         .pickImage(context, source: ImageSource.camera)
            //         .then(
            //             (value) => imageHelper.cropImage(context, path: value))
            //         .then((value) {
            //       setState(
            //         () => image = File(value),
            //       );
            //       context.pop();
            //       context.pop();
            //     }),
            //   ),
            //   child: Container(
            //     height: size * 4.5,
            //     width: double.infinity,
            //     margin: EdgeInsets.symmetric(horizontal: ten),
            //     decoration: BoxDecoration(
            //       color: ColourConfig.dull,
            //       borderRadius: defaultBorderRadius,
            //       image: image == null
            //           ? null
            //           : DecorationImage(
            //               image: FileImage(image!),
            //               fit: BoxFit.cover,
            //             ),
            //     ),
            //     child: Center(
            //         child: Icon(
            //       Icons.image,
            //       size: size,
            //     )),
            //   ),
            // ),
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
                                color: ColourConfig.dull,
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
                      AppButton(
                        label: 'Create',
                        onTap: () {
                          if (_nameController.text.trim().isEmpty) return;
                          final Workspace wrkspc = Workspace(
                            id: 'id',
                            name: _nameController.text.trim(),
                            desc: _descController.text.trim(),
                            participants: [auth.value?.uid],
                            creatorId: user!.uid,
                            createdAt: DateTime.now(),
                          );
                          WorkspaceDB().create(
                            context,
                            wrkspc: wrkspc,
                            userId: user.uid,
                            imagePath: image!.path,
                          );
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
