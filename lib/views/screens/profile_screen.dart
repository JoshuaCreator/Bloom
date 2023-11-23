import 'dart:io';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/dialogues/bottom_sheets.dart';
import 'package:basic_board/views/widgets/app_circle_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../dialogues/loading_indicator_build.dart';
import '../../utils/imports.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static String id = 'profile';
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ConsumerProfileScreenState();
}

class _ConsumerProfileScreenState extends ConsumerState<ProfileScreen> {
  String? fileImage;
  final ImageHelper imageHelper = ImageHelper();
  bool autofocusName = true;
  bool autofocusAbout = false;
  bool autofocusPhone = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final firestore = ref.watch(firestoreProvider);
    final auth = ref.watch(authStateProvider).value!;
    final nameController = TextEditingController(text: user.value?['name']);
    final aboutController = TextEditingController(text: user.value?['about']);
    final phoneController =
        TextEditingController(text: '${user.value?['phone']}');
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: EdgeInsets.only(
          top: ten,
          bottom: ten,
          left: ten,
          right: ten,
        ),
        children: [
          GestureDetector(
            onTap: () => imagePickerDialogue(
              context,
              onStorageTapped: () async {
                String imagePath = await imageHelper.pickImage(
                  context,
                  source: ImageSource.gallery,
                );
                if (context.mounted) {
                  String croppedImg =
                      await imageHelper.cropImage(context, path: imagePath);
                  if (context.mounted) {
                    context.pop();
                    context.pop();
                    showLoadingIndicator(context, label: 'Saving');
                  }
                  if (context.mounted) {
                    setState(() {
                      fileImage = croppedImg;
                    });
                    await imageHelper.uploadImage(
                      context,
                      imagePath: croppedImg,
                      docRef: firestore.collection('users').doc(auth.uid),
                      storagePath: 'users/${auth.uid}.png',
                      msg: 'Profile image saved',
                    );
                    if (context.mounted) context.pop();
                  }
                }
              },
              onCameraTapped: () async {
                String imagePath = await imageHelper.pickImage(
                  context,
                  source: ImageSource.camera,
                );
                if (context.mounted) {
                  String croppedImg =
                      await imageHelper.cropImage(context, path: imagePath);
                  if (context.mounted) {
                    setState(() {
                      fileImage = croppedImg;
                    });
                    await imageHelper.uploadImage(
                      context,
                      imagePath: croppedImg,
                      docRef: firestore.collection('users').doc(auth.uid),
                      storagePath: 'users/${auth.uid}.png',
                      msg: 'Profile image saved',
                    );
                  }
                  if (context.mounted) context.pop();
                }
              },
            ),
            child: Hero(
              tag: 'user-profile',
              child: fileImage == null
                  ? AppCircleAvatar(
                      image: user.value?['image'] == null
                          ? null
                          : CachedNetworkImageProvider(
                              user.value!['image'],
                            ),
                      userId: user.value?['id'],
                    )
                  : AppCircleAvatar(
                      image: FileImage(File(fileImage!)),
                      userId: user.value?['id'],
                    ),
            ),
          ),
          height40,
          UserInfoTile(
            leading: Icons.person_outline,
            title: user.value?['name'] ?? 'Tap to edit',
            subtitle: 'Name',
            onTap: () {
              autofocusName = true;
              autofocusAbout = false;
              autofocusPhone = false;
              save(
                context,
                nameController: nameController,
                aboutController: aboutController,
                phoneController: phoneController,
                user: user,
                firestore: firestore,
                auth: auth,
              );
            },
          ),
          height5,
          UserInfoTile(
            leading: Icons.info_outline_rounded,
            title: user.value?['about'] ?? 'Tap to edit',
            subtitle: 'About',
            onTap: () {
              autofocusName = false;
              autofocusAbout = true;
              autofocusPhone = false;
              save(
                context,
                nameController: nameController,
                aboutController: aboutController,
                phoneController: phoneController,
                user: user,
                firestore: firestore,
                auth: auth,
              );
            },
          ),
          height5,
          UserInfoTile(
            leading: Icons.phone,
            title: '${user.value?['phone'] ?? 'Tap to edit'}',
            subtitle: 'Phone',
            onTap: () {
              autofocusName = false;
              autofocusAbout = false;
              autofocusPhone = true;
              save(
                context,
                nameController: nameController,
                aboutController: aboutController,
                phoneController: phoneController,
                user: user,
                firestore: firestore,
                auth: auth,
              );
            },
          ),
        ],
      ),
    );
  }

  save(
    BuildContext context, {
    required TextEditingController nameController,
    required TextEditingController aboutController,
    required TextEditingController phoneController,
    required AsyncValue<Map<String, dynamic>?> user,
    required FirebaseFirestore firestore,
    required User auth,
  }) async {
    bool isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        showSnackBar(context, msg: "You're currently offline");
      }
      return;
    }
    if (context.mounted) {
      userInfoEditDialogue(
        context,
        nameController: nameController,
        aboutController: aboutController,
        phoneController: phoneController,
        autofocusName: autofocusName,
        autofocusAbout: autofocusAbout,
        autofocusPhone: autofocusPhone,
        onSaved: () {
          showLoadingIndicator(context, label: 'Saving...');
          if (nameController.text.trim() == user.value?['name']) {
            context.pop();
            context.pop();
            return;
          }

          firestore.collection('users').doc(auth.uid).update({
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'about': aboutController.text.trim(),
          }).then((value) {
            context.pop();
            context.pop();
            showSnackBar(
              context,
              msg: 'Info saved',
            );
          }).catchError((e) {
            context.pop();
            showSnackBar(
              context,
              msg: 'Oops! Unable to save. \n Try again',
            );
          });
        },
      );
    }
  }
}

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
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
