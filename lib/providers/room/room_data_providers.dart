//?*************** Get A Room ***************//
import 'package:basic_board/utils/imports.dart';

final roomProvider = StreamProvider.family(
  (ref, DocumentReference<Map<String, dynamic>> roomRef) {
    final collectionRef = roomRef;
    return collectionRef.snapshots().map((data) => data.data());
  },
);

//?*************** Get Rooms Of A Space ***************//
final spaceRoomsProvider = StreamProvider.family((ref, String spaceId) {
  final firestore = ref.watch(firestoreProvider);

  final collectionRef = firestore
      .collection('spaces')
      .doc(spaceId)
      .collection('rooms')
      .orderBy('createdAt', descending: true);
  return collectionRef.snapshots().map((data) => data.docs);
});

//?*************** Get Participants ******************//
final participantsProvider =
    StreamProvider.family((ref, CollectionReference participantsRef) {
  final collectionRef = participantsRef;

  return collectionRef.snapshots().map((data) => data.docs);
});
