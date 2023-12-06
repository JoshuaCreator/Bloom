import 'package:basic_board/utils/imports.dart';

/// This File is currently not in use. Until further notice
/// 
/// 
/// 
/// 

final spaceParticipantsProvider =
    StreamProvider.family((ref, String spaceId) {
  final firestore = ref.watch(firestoreProvider);
  final spaceRef = firestore
      .collection('workspaces')
      .doc(spaceId)
      .collection('participants');
  return spaceRef.snapshots().map((snapshot) => snapshot.docs);
});
