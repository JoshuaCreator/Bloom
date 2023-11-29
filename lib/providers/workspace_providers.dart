import 'package:basic_board/utils/imports.dart';

//?************** Get All Workspaces ***************//
final allWorkspacesProvider = StreamProvider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('workspaces');
  return collectionRef
      .orderBy('createdAt')
      .snapshots()
      .map((value) => value.docs);
});

//?************** Get Workspaces I joined ***************//
final myWorkspacesProvider = StreamProvider.family((ref, String userId) {
  final firestore = ref.watch(firestoreProvider);

  final collectionRef = firestore.collection('workspaces');
  return collectionRef
      .where('participants', arrayContains: userId)
      .snapshots()
      .map((docs) => docs.docs);
});

//?*************** Get a particular Workspaces ***************//
final workspaceProvider = StreamProvider.family((ref, String id) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('workspaces');
  return collectionRef.doc(id).snapshots().map((doc) => doc.data());
});

//?*************** Get Individial Workspaces *****************//
final wrkspcDataProvider = StreamProvider.family((ref, String wrkspcId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('workspaces');

  return userRef.doc(wrkspcId).snapshots().map((value) => value.data());
});
