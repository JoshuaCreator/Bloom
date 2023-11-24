import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/imports.dart';

class WorkspaceDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _workspaceRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final ImageHelper imageHelper = ImageHelper();

  Future<void> create(
    BuildContext context, {
    required Workspace wrkspc,
    required String userId,
    required String imagePath,
  }) async {
    _workspaceRef = _firestore.collection('workspaces');
    _firestore.settings = const Settings(persistenceEnabled: false);

    bool isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: "You're offline");
      }
      return;
    }

    try {
      if (context.mounted) showLoadingIndicator(context, label: 'Creating...');
      await _workspaceRef.add({
        'name': wrkspc.name,
        'desc': wrkspc.desc,
        'participants': wrkspc.participants,
        'creatorId': wrkspc.creatorId,
        'createdAt': wrkspc.createdAt,
      }).then((value) async {
        final String path = 'workspaces/${value.id}.png';

        _workspaceRef.doc(value.id).update({
          'id': value.id,
          'image': await imageHelper.uploadImage(
            context,
            imagePath: imagePath,
            docRef: _workspaceRef.doc(value.id),
            storagePath: path,
          )
        }).then((_) {
          context.pop();
          context.pop();
          showSnackBar(context, msg: '${wrkspc.name} has been created');
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
    required String wrkspcId,
    String? name,
    String? desc,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);

    bool isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: "You're offline");
      }
      return;
    }
    try {
      if (context.mounted) showLoadingIndicator(context);
      _firestore
          .collection('workspaces')
          .doc(wrkspcId)
          .update({'name': name, 'desc': desc}).then((value) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Workspace info updated successfully',
        );
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Oops! Unable to update Workspace info. \n Try again',
        );
      });
    } catch (e) {
      showSnackBar(context, msg: "An error occurred: $e");
    }
  }

  Future delete(
    BuildContext context, {
    required String wrkspcName,
    required String wrkspcId,
  }) async {
    _firestore.settings = const Settings(persistenceEnabled: false);

    bool isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: "You're offline");
      }
      return;
    }
    try {
      if (context.mounted) showLoadingIndicator(context, label: 'Deleting...');
      _firestore.collection('workspaces').doc(wrkspcId).delete().then((value) {
        context.go(WorkspaceScreen.id);
        showSnackBar(
          context,
          msg: "$wrkspcName deleted",
        );
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: "Unable to delete $wrkspcName",
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
