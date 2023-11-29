
import 'package:basic_board/utils/imports.dart';

//?*************** Get Last Message ******************//
final lastMessageProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> lastMessageRef) {
  return lastMessageRef.snapshots().map((data) => data.docs);
});

//?*************** Get Single Message ******************//
final messageProvider = StreamProvider.family(
    (ref, DocumentReference<Map<String, dynamic>> messageRef) {
  final docRef = messageRef;
  return docRef.snapshots().map((data) => data.data());
});

//?*************** Get All Messages ******************//
final messagesProvider =
    StreamProvider.family((ref, Query<Map<String, dynamic>> messagesRef) {
  return messagesRef
      .snapshots(includeMetadataChanges: true)
      .map((data) => data.docs);
});

//?*************** Get Replies ******************//
final repliesProvider =
    StreamProvider.family((ref, CollectionReference repliesRef) {
  final collectionRef = repliesRef;

  return collectionRef
      .orderBy('time', descending: true)
      .snapshots(includeMetadataChanges: true)
      .map((data) => data.docs);
});

//?*************** Get Number Of Replies ******************//
final repliesCountProvider =
    StreamProvider.family((ref, CollectionReference repliesRef) {
  final collectionRef = repliesRef;

  return collectionRef.snapshots().map((data) => data.docs);
});

//?*************** Get Number Of Likes ******************//
final likesCountProvider = StreamProvider.family(
    (ref, DocumentReference<Map<String, dynamic>> likesRef) {
  return likesRef.snapshots().map((doc) => doc.data()?['likes']);
});
