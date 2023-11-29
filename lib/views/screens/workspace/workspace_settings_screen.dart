import 'dart:io';
import 'package:basic_board/providers/workspace_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/workspace_db.dart';
import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';
import 'package:image_picker/image_picker.dart';

/// This File is currently not in use. Until further notice
/// 
/// 
/// 
/// 

class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  static String id = 'workspace-settings';
  const WorkspaceSettingsScreen({super.key, required this.wrkspc});
  final Workspace wrkspc;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  ConsumerState<WorkspaceSettingsScreen> createState() =>
      _ConsumerWorkspaceSettingsScreenState();
}

class _ConsumerWorkspaceSettingsScreenState
    extends ConsumerState<WorkspaceSettingsScreen> {
  bool canPop = false;

  String? image;
  final ImageHelper imageHelper = ImageHelper();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final workspace = ref.watch(workspaceProvider(widget.wrkspc.id!));
    final nameController =
        TextEditingController(text: workspace.value?['name']);
    final descController =
        TextEditingController(text: workspace.value?['desc']);
    return WillPopScope(
      onWillPop: () async {
        /// Prompts the user to save their changes only if they made any
        if (nameController.text == workspace.value?['name'] ||
            descController.text == workspace.value?['desc']) {
          canPop = true;
          return canPop;
        }
        if (nameController.text.trim().isEmpty) {
          canPop = false;
          showSnackBar(context, msg: 'Name field cannot be empty');
          return canPop;
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Save changes?'),
                actions: [
                  AppTextButton(
                    label: "Don't save",
                    onPressed: () {
                      canPop = true;
                      context.pop();
                      context.pop();
                    },
                  ),
                  AppTextButton(
                    label: "Save",
                    onPressed: () {},
                  ),
                ],
              );
            },
          );
          return canPop;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workspace Settings'),
          actions: [
            AppTextButton(
              onPressed: () async {
                bool isConnected = await isOnline();
                if (!isConnected) {
                  if (context.mounted) {
                    showSnackBar(context, msg: "You're offline");
                  }
                  return;
                }
                if (nameController.text == workspace.value?['name'] ||
                    descController.text == workspace.value?['desc']) {
                  if (context.mounted) {
                    showSnackBar(context, msg: 'No changes were made');
                  }
                  return;
                }
                if (context.mounted) {
                  saveChanges(
                    context,
                    nameController: nameController,
                    descController: descController,
                  );
                }
              },
              label: 'Save',
            )
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(ten),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    bool isConnected = await isOnline();
                    if (!isConnected) {
                      if (context.mounted) {
                        showSnackBar(context, msg: "You're offline");
                      }
                      return;
                    }
                    if (context.mounted) {
                      imagePickerDialogue(
                        context,
                        onStorageTapped: () async {
                          context.pop();
                          String imagePath = await imageHelper.pickImage(
                            context,
                            source: ImageSource.gallery,
                          );
                          if (context.mounted) {
                            String croppedImg = await imageHelper
                                .cropImage(context, path: imagePath);
                            if (context.mounted) {
                              context.pop();
                              showLoadingIndicator(context, label: 'Saving...');
                            }
                            if (context.mounted) {
                              setState(() {
                                image = croppedImg;
                              });
                              // await imageHelper.uploadImage(
                              //   context,
                              //   imagePath: croppedImg,
                              //   docRef: firestore
                              //       .collection('workspaces')
                              //       .doc(widget.wrkspc.id!),
                              //   storagePath:
                              //       'workspaces/${widget.wrkspc.id!}.png',
                              // );
                              if (context.mounted) context.pop();
                            }
                          }
                        },
                        onCameraTapped: () async {
                          context.pop();
                          String imagePath = await imageHelper.pickImage(
                            context,
                            source: ImageSource.camera,
                          );
                          if (context.mounted) {
                            String croppedImg = await imageHelper
                                .cropImage(context, path: imagePath);
                            if (context.mounted) {
                              context.pop();
                              showLoadingIndicator(context, label: 'Saving...');
                            }
                            if (context.mounted) {
                              setState(() {
                                image = croppedImg;
                              });

                              if (context.mounted) context.pop();
                            }
                          }
                        },
                      );
                    }
                  },
                  child: Container(
                    width: size * 5,
                    height: size * 5,
                    decoration: BoxDecoration(
                      color: ColourConfig.dull,
                      borderRadius: BorderRadius.circular(size),
                      image: image == null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  workspace.value?['image']),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: FileImage(File(image!)),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                )
              ],
            ),
            height10,
            Form(
              key: WorkspaceSettingsScreen.formKey,
              child: Column(
                children: [
                  AppTextField(
                    hintText: 'Name (required)',
                    borderless: true,
                    controller: nameController,
                    // onChanged: (value) {
                    //   nameController.text = value;
                    // },
                  ),
                  height10,
                  AppTextField(
                    hintText: 'Description',
                    borderless: true,
                    controller: descController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    // onChanged: (value) {
                    //   descController.text = value;
                    // },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  saveChanges(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController descController,
  }) async {
    showLoadingIndicator(context, label: 'Saving...');
    await WorkspaceDB().edit(
      context,
      wrkspcId: widget.wrkspc.id!,
      name: nameController.text.trim(),
      desc: descController.text.trim(),
    );
    if (context.mounted) {
      await imageHelper.uploadImage(
        context,
        imagePath: image!,
        docRef: firestore.collection('workspaces').doc(widget.wrkspc.id!),
        storagePath: 'workspaces/${widget.wrkspc.id!}.png',
      );
    }
  }
}
