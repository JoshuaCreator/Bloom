import 'package:basic_board/utils/imports.dart';

/// This File is currently not in use. Until further notice
/// 
/// 
/// 
/// 

//?*************** Get direct chats ***************//
final directChatsProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> chatRef) {
  return chatRef.snapshots().map((docs) => docs.docs);
});

//?*************** Get messages of a chat ***************//
final msgProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> chatRef) {
  return chatRef
      .orderBy('time', descending: true)
      .snapshots()
      .map((data) => data.docs);
});
