import 'package:basic_board/views/widgets/profile_tile.dart';
import 'package:basic_board/views/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../services/auth.dart';

class AccountScreen extends ConsumerWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider).value;
    final email = auth?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              Auth().signOut(context);
              context.pop();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        // padding: EdgeInsets.all(ten),
        children: [
          ProfileTile(user: user, email: email),
          SettingTile(
            title: 'Account',
            subtitle: 'Manage account',
            leading: Icons.key_rounded,
            onTap: () {},
          ),
          SettingTile(
            title: 'Privacy',
            subtitle: 'Make account more private',
            leading: Icons.lock_rounded,
            onTap: () {},
          ),
          SettingTile(
            title: 'Notifications',
            subtitle: 'Change notification settings',
            leading: Icons.notifications_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
