import 'package:basic_board/providers/users_providers.dart';
import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/views/widgets/settings_tile.dart';
import 'package:basic_board/views/widgets/profile_tile.dart';
import '../../services/auth.dart';
import '../../utils/imports.dart';

class SettingsScreen extends ConsumerWidget {
  static String id = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider).value;
    final user = ref.watch(anyUserProvider(auth!.uid));
    final firestore = ref.watch(firestoreProvider);
    final email = auth.email;
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
                  title: user.value?['active'] == true
                      ? "You're currently Active"
                      : "You're currently Away",
                  leading: user.value?['active'] == true
                      ? Icons.person_pin_circle_outlined
                      : Icons.person_off_outlined,
                  onTap: () async {
                    bool isConnected = await isOnline();
                    if (!isConnected) {
                      if (context.mounted) {
                        showSnackBar(context, msg: "You're offline");
                      }
                      return;
                    }
                    firestore.collection('users').doc(auth.uid).update({
                      'active': user.value?['active'] == true ? false : true,
                    });
                  },
                ),
                SettingTile(
                  title: 'Account',
                  leading: Icons.account_circle_outlined,
                  onTap: () {
                    context.push(
                      '${SpaceScreen.id}/${SettingsScreen.id}/${AccountScreen.id}',
                    );
                  },
                ),
                const Separator(),
                SettingTile(
                  title: 'Appearance',
                  leading: Icons.light_mode_outlined,
                  onTap: () {
                    context.push(
                      '${SpaceScreen.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
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
