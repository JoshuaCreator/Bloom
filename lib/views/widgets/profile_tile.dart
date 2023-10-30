import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../configs/consts.dart';
import '../screens/account_screen.dart';
import '../screens/home_screen.dart';
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
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          onTap: () {
            context.push(
              '${HomeScreen.id}/${SettingsScreen.id}/${AccountScreen.id}',
            );
          },
          child: Ink(
            padding: EdgeInsets.fromLTRB(ten, twenty, ten, twenty),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: thirty),
                    SizedBox(width: ten),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size * 5,
                          child: Text(
                            user.value?['fName'] + ' ' + user.value?['lName'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          width: size * 5,
                          child: Text(
                            email!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 0, thickness: 0.3, color: Colors.grey.shade700),
        height10,
      ],
    );
  }
}
