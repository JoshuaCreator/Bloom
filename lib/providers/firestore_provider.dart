import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

// ⭐⭐ RETRIEVE DATA FROM FIRESTORE USING RIVERPOD ⭐⭐

//? *************** Get Anouncements ***************//
final anouncementProvider = StreamProvider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);

    var docRef =
        firestore.collection('anouncements').orderBy('time', descending: true);
    return docRef.snapshots().map((data) => data.docs);
  },
);

//? *************** Get User ***************//
final userProvider = StreamProvider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    final userStream = ref.watch(authStateProvider);

    var user = userStream.value;
    var docRef = firestore.collection('users').doc(user?.email);
    return docRef.snapshots().map((doc) => doc.data());
  },
);

//? *************** Get Rooms ***************//
final roomProvider = StreamProvider(
  (ref) {
    // final userStream = ref.watch(authStateProvider);
    final firestore = ref.watch(firestoreProvider);

    var docRef =
        firestore.collection('rooms').orderBy('createdAt', descending: true);
    return docRef.snapshots().map((data) => data.docs);
  },
);

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
