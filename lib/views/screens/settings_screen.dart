import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/widgets/app_text_buttons.dart';
import 'package:basic_board/views/widgets/profile_tile.dart';
import 'package:basic_board/views/widgets/seperator.dart';
import 'package:basic_board/views/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/firestore_provider.dart';
import '../../services/auth.dart';
import 'home_screen.dart';
import 'theme_selector_screen.dart';

class SettingsScreen extends ConsumerWidget {
  static String id = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider).value;
    final email = auth?.email;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // padding: EdgeInsets.all(ten),
              children: [
                ProfileTile(user: user, email: email),
                const Seperator(),
                SettingTile(
                  title: 'Account',
                  leading: Icons.account_circle_outlined,
                  onTap: () {},
                ),
                const Seperator(),
                SettingTile(
                  title: 'Privacy',
                  leading: Icons.lock_outline,
                  onTap: () {},
                ),
                SettingTile(
                  title: 'Notifications',
                  leading: Icons.notifications_outlined,
                  onTap: () {},
                ),
                SettingTile(
                  title: 'Appearance',
                  leading: Icons.light_mode_outlined,
                  onTap: () {
                    context.push(
                      '${HomeScreen.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
                    );
                  },
                ),
                const Seperator(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: ten),
            child: AppTextButtonIcon(
              label: 'Log out',
              icon: Icons.logout_rounded,
              onPressed: () {
                Auth().signOut(context);
                context.go(LoginScreen.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
