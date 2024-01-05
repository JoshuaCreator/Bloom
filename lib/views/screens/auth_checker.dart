import 'package:basic_board/utils/imports.dart';
import 'package:basic_board/views/screens/verify_email_screen.dart';
import 'package:basic_board/views/widgets/b_nav_bar.dart';

class AuthChecker extends ConsumerWidget {
  static String id = '/';
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null && data.emailVerified) {
          return const BNavBar();
        } else if (data != null && !data.emailVerified) {
          return const VerifyEmailScreen();
        }
        return const LoginScreen();
      },
      error: (error, stackTrace) => const Center(
        child: Text('An error occurred'),
      ),
      loading: () => const Center(child: LoadingIndicator()),
    );
  }
}
