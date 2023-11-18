import 'package:basic_board/models/dept.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/imports.dart';

class DeptDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _deptRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> create(BuildContext context,
      {required Department dept, required String userId}) async {
    _deptRef = _firestore.collection('departments');

    try {
      showLoadingIndicator(context, label: 'Creating...');
      await _deptRef.add({
        'name': dept.name,
        'desc': dept.desc,
        'participants': dept.participants,
        'creatorId': dept.creatorId,
        'createdAt': dept.createdAt,
      }).then((value) {
        _deptRef.doc(value.id).update({
          'id': value.id,
          'rooms': [value.id]
        });
        _deptRef.doc(value.id).collection('participants').doc(userId).set({
          'id': userId,
          'joined': DateTime.now(),
        }).then((value) {
          context.pop();
          context.pop();
          showSnackBar(context, msg: '${dept.name} has been created');
        });
      }).catchError((e) {
        context.pop();
        showSnackBar(context, msg: 'An error occurred: $e');
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          context.pop();
          showSnackBar(context, msg: 'The connection timed out');
        },
      );
    } catch (e) {
      if (context.mounted) showSnackBar(context, msg: 'An error occurred: $e');
    }
  }
}
