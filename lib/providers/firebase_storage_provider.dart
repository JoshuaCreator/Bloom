import 'package:firebase_storage/firebase_storage.dart';

import '../utils/imports.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});
