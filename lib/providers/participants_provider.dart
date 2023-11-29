import 'package:basic_board/utils/imports.dart';

/// This File is currently not in use. Until further notice
/// 
/// 
/// 
/// 

final workspaceParticipantsProvider =
    StreamProvider.family((ref, String workspaceId) {
  final firestore = ref.watch(firestoreProvider);
  final workspaceRef = firestore
      .collection('workspaces')
      .doc(workspaceId)
      .collection('participants');
  return workspaceRef.snapshots().map((snapshot) => snapshot.docs);
});
