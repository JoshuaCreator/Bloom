import 'package:basic_board/services/connection_state.dart';
import 'package:basic_board/services/image_helper.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/imports.dart';

class SpaceDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _spaceRef;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  final ImageHelper imageHelper = ImageHelper();

  Future<void> create(
    BuildContext context, {
    required Space wrkspc,
    required String userId,
    required String? imagePath,
  }) async {
    _spaceRef = _firestore.collection('workspaces');

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
      await _spaceRef.add({
        'name': wrkspc.name,
        'desc': wrkspc.desc,
        'image': imagePath,
        'creatorId': wrkspc.creatorId,
        'createdAt': wrkspc.createdAt,
        'private': wrkspc.private,
      }).then((doc) async {
        final String path = 'workspaces/${doc.id}.png';
        _spaceRef.doc(doc.id).update({
          'id': doc.id,
          'participants': FieldValue.arrayUnion([userId]),
        }).then((_) {
          _spaceRef
              .doc(doc.id)
              .collection('participants')
              .doc(userId)
              .set({'id': userId, 'joined': DateTime.now()});
        }).then((_) {
          context.pop();
          context.pop();
          showSnackBar(context, msg: '${wrkspc.name} has been created');
        });
        imagePath == null || imagePath.isEmpty
            ? null
            : await imageHelper
                .uploadImage(
                  context,
                  imagePath: imagePath,
                  docRef: _spaceRef.doc(doc.id),
                  storagePath: path,
                )
                .then((downloadUrl) =>
                    _spaceRef.doc(doc.id).update({'image': downloadUrl}));
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

  Future join(
    BuildContext context, {
    required Space space,

    /// The required [userId] refers to the currently signed in user
    required String userId,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        showSnackBar(context, msg: "You're offline'");
      }
      return;
    }
    _spaceRef = _firestore.collection('workspaces');
    try {
      if (context.mounted) showLoadingIndicator(context, label: 'Joining...');
      _spaceRef.doc(space.id).update({
        'participants': FieldValue.arrayUnion([userId])
      });
      _spaceRef
          .doc(space.id)
          .collection('participants')
          .doc(userId)
          .update({'id': userId, 'joined': DateTime.now()});
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: 'You joined ${space.name}');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, msg: 'An error occurred: $e');
      }
    }
  }

  Future exit(
    BuildContext context, {
    required Space space,

    /// The required [userId] refers to the currently signed in user
    required String userId,
  }) async {
    final isConnected = await isOnline();
    if (!isConnected) {
      if (context.mounted) {
        showSnackBar(context, msg: "You're offline");
      }
      return;
    }
    _spaceRef = _firestore.collection('workspaces');
    try {
      if (context.mounted) showLoadingIndicator(context, label: 'Exiting...');
      _spaceRef.doc(space.id).update({
        'participants': FieldValue.arrayRemove([userId])
      });
      _spaceRef.doc(space.id).collection('participants').doc(userId).delete();
      if (context.mounted) {
        context.pop();
        showSnackBar(context, msg: 'You left ${space.name}');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, msg: 'An error occurred: $e');
      }
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
        showSnackBar(context, msg: 'Space info updated successfully');
      }).catchError((e) {
        context.pop();
        context.pop();
        showSnackBar(
          context,
          msg: 'Unable to update Space info. \n Try again',
        );
      });
    } catch (e) {
      if (context.mounted) showSnackBar(context, msg: "An error occurred: $e");
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
        context.go(SpaceScreen.id);
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
          return;
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, msg: "An error occurred: $e");
      }
    }
  }
}
