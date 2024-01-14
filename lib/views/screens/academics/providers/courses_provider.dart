import 'package:basic_board/providers/auth_provider.dart';
import 'package:basic_board/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coursesProvider = StreamProvider((ref) {
  final user = ref.watch(authStateProvider).value;
  final firestore = ref.watch(firestoreProvider);
  final collectionRef =
      firestore.collection('users').doc(user?.uid).collection('courses');
  return collectionRef.snapshots().map((doc) => doc.docs);
});
