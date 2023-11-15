import 'package:basic_board/utils/imports.dart';

class AccountScreen extends ConsumerWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final email = ref.watch(authStateProvider).value!.email;
    // final emailController = TextEditingController(text: email);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: EdgeInsets.only(top: ten),
        children: [
          //! Feature suspended due to feature being disabled in Firebase
          // ListTile(
          //   leading: const Icon(Icons.email_outlined),
          //   title: const Text('Change email'),
          //   subtitle: Text('Current email: $email'),
          //   onTap: () {
          //     changeEmailBOttomSheet(
          //       context,
          //       emailController: emailController,
          //       onSaved: () {
          //         Auth().updateEmail(
          //           context,
          //           newEmail: emailController.text.trim(),
          //         );
          //       },
          //     );
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Delete account'),
            onTap: () {
              deleteAccountDialogue(context);
            },
          ),
        ],
      ),
    );
  }
}
