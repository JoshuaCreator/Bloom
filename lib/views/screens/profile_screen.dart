import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/configs/text_config.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/image_picker_dialogue.dart';
import 'package:basic_board/views/dialogues/info_edit_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../dialogues/loading_indicator_build.dart';
import '../dialogues/snack_bar.dart';

class ProfileScreen extends ConsumerWidget {
  static String id = 'profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value!;
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
                //! Pick Image From Device Storage
              },
              onCameraTapped: () {
                //! Pick Image From Camera
              },
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'user-profile',
                  child: CircleAvatar(
                    radius: size * 2,
                    // child: Text(user.value!['fName'].toString().substring(0, 1)),
                    backgroundImage: user.value!['image'] == null
                        ? null
                        : CachedNetworkImageProvider(user.value!['image']),
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
        showLoadingIndicator(context);
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
        showLoadingIndicator(context);
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
