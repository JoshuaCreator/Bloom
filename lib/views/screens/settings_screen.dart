import 'package:basic_board/views/widgets/settings_tile.dart';
import 'package:basic_board/views/widgets/profile_tile.dart';
import '../../services/auth.dart';
import '../../utils/imports.dart';

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
              children: [
                ProfileTile(user: user, email: email),
                const Separator(),
                SettingTile(
                  title: 'Account',
                  leading: Icons.account_circle_outlined,
                  onTap: () {
                    context.push(
                      '${DeptScreen.id}/${HomeScreen.id}/${SettingsScreen.id}/${AccountScreen.id}',
                    );
                  },
                ),
                const Separator(),
                SettingTile(
                  title: 'Appearance',
                  leading: Icons.light_mode_outlined,
                  onTap: () {
                    context.push(
                      '${DeptScreen.id}/${HomeScreen.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
                    );
                  },
                ),
                const Separator(),
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
