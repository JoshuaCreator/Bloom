import 'package:basic_board/models/dept.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/screens/dept_screen.dart';
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
          'Departments': [value.id]
        }).then((_) {
          context.pop();
          context.pop();
          // context.push(
          //   '${DeptScreen.id}/${HomeScreen.id}/${CreateRoomScreen.id}/${value.id}',
          // );
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

  Future edit(
    BuildContext context, {
    required String deptId,
    String? name,
    String? desc,
  }) async {
    try {
      showLoadingIndicator(context);
      _firestore
          .collection('departments')
          .doc(deptId)
          .update({'name': name, 'desc': desc}).then((value) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Department info updated successfully',
        );
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Oops! Unable to update Department info. \n Try again',
        );
      });
    } catch (e) {
      showSnackBar(context, msg: "An error occurred: $e");
    }
  }

  Future delete(
    BuildContext context, {
    required String deptName,
    required String deptId,
  }) async {
    try {
      showLoadingIndicator(context, label: 'Deleting...');
      _firestore.collection('departments').doc(deptId).delete().then((value) {
        context.go(DeptScreen.id);
        showSnackBar(
          context,
          msg: "$deptName deleted",
        );
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: "Unable to delete $deptName",
        );
      }).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          context.pop();
          showSnackBar(
            context,
            msg:
                'The connection timed out. Check your internet connection and try again',
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        msg: "An error occurred: $e",
      );
    }
  }
}
