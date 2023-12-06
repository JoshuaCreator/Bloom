import 'dart:io';
import 'package:basic_board/providers/space_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/services/space_db.dart';
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

class SpaceSettingsScreen extends ConsumerStatefulWidget {
  static String id = 'space-settings';
  const SpaceSettingsScreen({super.key, required this.space});
  final Space space;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  ConsumerState<SpaceSettingsScreen> createState() =>
      _ConsumerSpaceSettingsScreenState();
}

class _ConsumerSpaceSettingsScreenState
    extends ConsumerState<SpaceSettingsScreen> {
  bool canPop = false;

  String? image;
  final ImageHelper imageHelper = ImageHelper();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final space = ref.watch(spaceDataProvider(widget.space.id!));
    final nameController = TextEditingController(text: space.value?['name']);
    final descController = TextEditingController(text: space.value?['desc']);
    return WillPopScope(
      onWillPop: () async {
        /// Prompts the user to save their changes only if they made any
        if (nameController.text == space.value?['name'] ||
            descController.text == space.value?['desc']) {
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
          title: const Text('Space Settings'),
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
                if (nameController.text == space.value?['name'] ||
                    descController.text == space.value?['desc']) {
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
                              //       .collection('spaces')
                              //       .doc(widget.space.id!),
                              //   storagePath:
                              //       'spaces/${widget.space.id!}.png',
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
                      color: ColourConfig.grey,
                      borderRadius: BorderRadius.circular(size),
                      image: image == null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  space.value?['image']),
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
              key: SpaceSettingsScreen.formKey,
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
    await SpaceDB().edit(
      context,
      spaceId: widget.space.id!,
      name: nameController.text.trim(),
      desc: descController.text.trim(),
    );
    if (context.mounted) {
      await imageHelper.uploadImage(
        context,
        imagePath: image!,
        docRef: firestore.collection('spaces').doc(widget.space.id!),
        storagePath: 'spaces/${widget.space.id!}.png',
      );
    }
  }
}
