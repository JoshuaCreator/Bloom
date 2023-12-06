import 'package:basic_board/utils/imports.dart';

//?************** Get All Spaces ***************//
final allSpacesProvider = StreamProvider((ref) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('spaces');
  return collectionRef
      .orderBy('createdAt')
      .snapshots()
      .map((value) => value.docs);
});

//?************** Get Spaces I joined ***************//
final mySpacesProvider = StreamProvider.family((ref, String userId) {
  final firestore = ref.watch(firestoreProvider);

  final collectionRef = firestore.collection('spaces');
  return collectionRef
      .where('participants', arrayContains: userId)
      .snapshots()
      .map((docs) => docs.docs);
});

//?*************** Get a particular Spaces ***************//
final spaceProvider = StreamProvider.family((ref, String id) {
  final firestore = ref.watch(firestoreProvider);
  final collectionRef = firestore.collection('spaces');
  return collectionRef.doc(id).snapshots().map((doc) => doc.data());
});

//?*************** Get Individial Spaces *****************//
final spaceDataProvider = StreamProvider.family((ref, String spaceId) {
  final firestore = ref.watch(firestoreProvider);
  final userRef = firestore.collection('spaces');

  return userRef.doc(spaceId).snapshots().map((value) => value.data());
});
