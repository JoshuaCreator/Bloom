import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../configs/consts.dart';
import '../screens/workspace_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.user,
    required this.email,
  });

  final AsyncValue<Map<String, dynamic>?> user;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.push(
              '${WorkspaceScreen.id}/${SettingsScreen.id}/${ProfileScreen.id}',
            );
          },
          child: Ink(
            padding: EdgeInsets.fromLTRB(ten, twenty, ten, twenty),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'user-profile',
                  child: CircleAvatar(
                      radius: thirty,
                      backgroundImage: CachedNetworkImageProvider(
                        user.value?['image'] ?? '',
                      )),
                ),
                SizedBox(width: ten),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size * 5,
                      child: Text(
                        user.value?['name'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Text(
                      email ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
