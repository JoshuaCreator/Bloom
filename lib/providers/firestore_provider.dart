import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

// ⭐⭐ RETRIEVE DATA FROM FIRESTORE ⭐⭐

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

//? *************** Get A Room ***************//
final roomProvider = StreamProvider.family(
  (ref, DocumentReference<Map<String, dynamic>> roomRef) {
    final collectionRef = roomRef;
    return collectionRef.snapshots().map((data) => data.data());
  },
);

//? *************** Get Rooms Of A Workspace ***************//
final wrkspcRoomsProvider = StreamProvider.family(
  (ref, String workspaceId) {
    final firestore = ref.watch(firestoreProvider);

    final collectionRef = firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('rooms')
        .orderBy('createdAt', descending: true);
    return collectionRef.snapshots().map((data) => data.docs);
  },
);

//? *************** Get Workspaces ***************//
final wrkspcsProvider = StreamProvider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('workspaces');
  return collectionRef
      .orderBy('createdAt')
      .snapshots()
      .map((value) => value.docs);
});

//? *************** Get Individial Workspaces *****************//
final wrkspcDataProvider = StreamProvider.family((ref, String wrkspcId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('workspaces');

  return userRef.doc(wrkspcId).snapshots().map((value) => value.data());
});

//? *************** Get Participants ******************//
final participantsProvider =
    StreamProvider.family((ref, CollectionReference participantsRef) {
  final collectionRef = participantsRef;

  return collectionRef.snapshots().map((data) => data.docs);
});

//? *************** Get Replies ******************//
final repliesProvider =
    StreamProvider.family((ref, CollectionReference repliesRef) {
  final collectionRef = repliesRef;

  return collectionRef
      .orderBy('time', descending: true)
      .snapshots(includeMetadataChanges: true)
      .map((data) => data.docs);
});

//? *************** Get Number Of Replies ******************//
final repliesCountProvider =
    StreamProvider.family((ref, CollectionReference repliesRef) {
  final collectionRef = repliesRef;

  return collectionRef.snapshots().map((data) => data.docs);
});

//? *************** Get Last Message ******************//
final lastMessageProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> lastMessageRef) {
  final collectionRef = lastMessageRef;
  return collectionRef.snapshots().map((data) => data.docs);
});

//? *************** Get All Messages ******************//
final messagesProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> messagesRef) {
  final collectionRef = messagesRef;
  return collectionRef
      .snapshots(includeMetadataChanges: true)
      .map((data) => data.docs);
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
