import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:basic_board/views/dialogues/image_picker_dialogue.dart';
import 'package:basic_board/views/dialogues/name_edit_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  static String id = 'account';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
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
                CircleAvatar(
                  radius: size * 2,
                  // child: Text(user.value!['fName'].toString().substring(0, 1)),
                  backgroundImage: user.value!['image'] == null
                      ? null
                      : CachedNetworkImageProvider(user.value!['image']),
                ),
                height5,
                const Text('Edit image', textAlign: TextAlign.center),
              ],
            ),
          ),
          height40,
          UserTile(
            leading: Icons.person_outline,
            title: user.value?['fName'] + ' ' + user.value?['lName'],
            subtitle: 'Name',
          ),
          height5,
          UserTile(
            leading: Icons.info_outline_rounded,
            title: user.value?['about'] ?? 'This is my about',
            subtitle: 'About',
          ),
        ],
      ),
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

  final String title;
  final String subtitle;
  final IconData leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: textStyle,
      ),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => nameEditDialogue(
        context,
        onSaved: () {
          //! Save User Info
        },
      ),
    );
  }
}
