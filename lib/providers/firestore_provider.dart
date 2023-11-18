import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

// ⭐⭐ RETRIEVE DATA FROM FIRESTORE ⭐⭐

//? *************** Get Anouncements ***************//
final anouncementProvider = StreamProvider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);

    var docRef =
        firestore.collection('anouncements').orderBy('time', descending: true);
    return docRef.snapshots().map((data) => data.docs);
  },
);

//? *************** Get Current User ***************//
final userProvider = StreamProvider(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    final userStream = ref.watch(authStateProvider);

    var user = userStream.value;
    var docRef = firestore.collection('users').doc(user?.uid);
    return docRef.snapshots().map((doc) => doc.data());
  },
);

//? *************** Get Any User *****************//
final anyUserProvider = StreamProvider.family((ref, String userId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('users');

  return userRef.doc(userId).snapshots().map((user) => user.data());
});

// //? *************** Get Room Image *****************//
// final roomImageProvider = StreamProvider.family((ref, DocumentReference roomCollection) {
//   final firestore = ref.watch(firestoreProvider);
//   final roomRef = firestore.roomCollection;
  

//   return roomRef.snapshots().map((value) => value.data());
// });

//? *************** Get Rooms ***************//
final roomProvider = StreamProvider.family(
  (ref, String deptId) {
    final firestore = ref.watch(firestoreProvider);

    final collectionRef = firestore
        .collection('departments')
        .doc(deptId)
        .collection('rooms')
        .orderBy('createdAt', descending: true);
    return collectionRef.snapshots().map((data) => data.docs);
  },
);

//? *************** Get Departments ***************//
final deptsProvider = StreamProvider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('departments');
  return collectionRef.snapshots().map((value) => value.docs);
});

//? *************** Get Individial Departments *****************//
final deptDataProvider = StreamProvider.family((ref, String deptId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('departments');

  return userRef.doc(deptId).snapshots().map((value) => value.data());
});

//? *************** Get Last Message ******************//
final lastMessageProvider = StreamProvider.family((ref, String roomId) {
  final firestore = ref.watch(firestoreProvider);

  var collectionRef = firestore
      .collection('rooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('time', descending: true)
      .limit(1);
  return collectionRef.snapshots().map((data) => data.docs);
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
