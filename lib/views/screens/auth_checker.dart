import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/screens/verify_email_screen.dart';

class AuthChecker extends ConsumerWidget {
  static String id = '/';
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null && data.emailVerified) {
          return const HomeScreen();
        } else if (data != null && !data.emailVerified) {
          
          return const VerifyEmailScreen();
        }
        return const LoginScreen();
      },
      error: (error, stackTrace) => const Center(
        child: Text('An error occurred'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
