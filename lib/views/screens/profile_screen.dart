import 'dart:io';

import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/dialogues/info_edit_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../dialogues/loading_indicator_build.dart';
import '../dialogues/snack_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static String id = 'profile';
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends ConsumerState<ProfileScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value!;
    var userRef = firestore.collection('users');
    final nameController = TextEditingController(text: user.value?['name']);
    final aboutController = TextEditingController(text: user.value?['about']);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: EdgeInsets.only(
          top: size * 2,
          bottom: ten,
          left: ten,
          right: ten,
        ),
        children: [
          GestureDetector(
            onTap: () => imagePickerDialogue(
              context,
              onStorageTapped: () {
                _pickImage(ImageSource.gallery).then((value) {
                  showLoadingIndicator(context, label: 'Saving...');
                  _uploadImage(
                    context,
                    image: image,
                    userRef: userRef,
                    userId: user.value?['id'],
                  ).then((value) => context.pop());
                });
              },
              onCameraTapped: () {
                _pickImage(ImageSource.camera).then((value) {
                  showLoadingIndicator(context, label: 'Saving...');
                  _uploadImage(
                    context,
                    image: image,
                    userRef: userRef,
                    userId: user.value?['id'],
                  ).then((value) => context.pop());
                });
              },
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'user-profile',
                  child: image == null
                      ? CircleAvatar(
                          radius: size * 2,
                          backgroundImage: user.value!['image'] == null
                              ? null
                              : CachedNetworkImageProvider(
                                  user.value!['image'],
                                ),
                        )
                      : CircleAvatar(
                          radius: size * 2,
                          backgroundImage: FileImage(image!),
                        ),
                ),
                height5,
                const Text('Tap to edit', textAlign: TextAlign.center),
              ],
            ),
          ),
          height40,
          UserTile(
            leading: Icons.person_outline,
            title: user.value?['name'] ?? 'Tap to edit',
            subtitle: 'Name',
            onTap: () => editName(
              context,
              nameController: nameController,
              user: user,
              firestore: firestore,
              auth: auth,
            ),
          ),
          height5,
          UserTile(
            leading: Icons.info_outline_rounded,
            title: user.value?['about'] ?? 'Tap to edit',
            subtitle: 'About',
            onTap: () => editAbout(
              context,
              aboutController: aboutController,
              user: user,
              firestore: firestore,
              auth: auth,
            ),
          ),
        ],
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
          await cropper.cropImage(sourcePath: image.path);
      final File temporaryImage = File(croppedImg!.path);
      setState(() {
        this.image = temporaryImage;
      });

      if (context.mounted) context.pop();
    }
  }

  editName(
    BuildContext context, {
    required TextEditingController nameController,
    required AsyncValue<Map<String, dynamic>?> user,
    required FirebaseFirestore firestore,
    required User auth,
  }) {
    infoEditDialogue(
      context,
      showAbout: false,
      title: 'Edit name',
      nameController: nameController,
      onSaved: () {
        showLoadingIndicator(context, label: 'Saving...');
        if (nameController.text.trim() == user.value?['name']) {
          context.pop();
          context.pop();
          return;
        }

        firestore.collection('users').doc(auth.uid).update({
          'name': nameController.text.trim(),
        }).then((value) {
          context.pop();
          context.pop();
          showSnackBar(
            context,
            msg: 'Display name saved',
          );
        }).catchError((e) {
          context.pop();
          showSnackBar(
            context,
            msg: 'Oops! Unable to save display name. \n Try again',
          );
        });
      },
    );
  }

  editAbout(
    BuildContext context, {
    required TextEditingController aboutController,
    required AsyncValue<Map<String, dynamic>?> user,
    required FirebaseFirestore firestore,
    required User auth,
  }) {
    infoEditDialogue(
      context,
      showName: false,
      title: 'Edit about',
      aboutController: aboutController,
      onSaved: () {
        showLoadingIndicator(context, label: 'Saving...');
        if (aboutController.text.trim() == user.value?['about']) {
          context.pop();
          context.pop();
          return;
        }

        firestore.collection('users').doc(auth.uid).update({
          'about': aboutController.text.trim(),
        }).then((value) {
          context.pop();
          context.pop();
          showSnackBar(
            context,
            msg: 'About saved',
          );
        }).catchError((e) {
          context.pop();
          showSnackBar(
            context,
            msg: 'Oops! Unable to save about. \n Try again',
          );
        });
      },
    );
  }
}

Future<void> _uploadImage(
  BuildContext context, {
  required File? image,
  required CollectionReference userRef,
  required String userId,
}) async {
  final path = 'users/$userId/${image?.path}';
  try {
    final storageRef = FirebaseStorage.instance;

    final uploadTask = await storageRef.ref().child(path).putFile(image!);

    // final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    userRef.doc(userId).update({'image': downloadUrl});
  } on FirebaseException catch (e) {
    if (context.mounted) showSnackBar(context, msg: 'An error occurred: $e');
  }
}

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    this.onTap,
  });

  final String title, subtitle;
  final IconData leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextConfig.intro,
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: onTap,
    );
  }
}
