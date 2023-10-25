import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth.dart';

final authProvider = Provider<Auth>((ref) {
  return Auth();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authState;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
