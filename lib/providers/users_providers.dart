
//?*************** Get Current User ***************//
import 'package:basic_board/utils/imports.dart';

final userProvider = StreamProvider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    final userStream = ref.watch(authStateProvider);

    var user = userStream.value;
    var docRef = firestore.collection('users').doc(user?.uid);
    return docRef.snapshots().map((doc) => doc.data());
  },
);

//?*************** Get Any User *****************//
final anyUserProvider = StreamProvider.family((ref, String userId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('users');

  return userRef.doc(userId).snapshots().map((user) => user.data());
});
