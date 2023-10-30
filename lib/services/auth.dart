import 'package:basic_board/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/views/screens/home_screen.dart';
import 'package:basic_board/views/screens/verify_email_screen.dart';
import 'package:basic_board/views/dialogues/loading_indicator_build.dart';
import 'package:basic_board/views/dialogues/snack_bar.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _userRef;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<void> logIn(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    showLoadingIndicator(context);
    try {
      if (email.isEmpty || password.isEmpty) {
        showSnackBar(context,
            msg: 'Neither Email nor Password fields should be empty');
        context.pop();
        return;
      }
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        context.pop();
        if (!_auth.currentUser!.emailVerified) {
          context.go(VerifyEmailScreen.id);
        } else {
          context.go(HomeScreen.id);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          showSnackBar(context, msg: 'This email address is not recognised');
        }
        if (context.mounted) {
          context.pop();
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          showSnackBar(context, msg: 'The Password you entered is incorrect');
        }
        if (context.mounted) {
          context.pop();
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, msg: '${e.message}');
        }
        if (context.mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        context.pop();
      }
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    }
  }

  Future<void> register(
    BuildContext context, {
    required String email,
    required String password,
    required AppUser user,
  }) async {
    _userRef = _firestore.collection('users');
    showLoadingIndicator(context);
    try {
      if (email.isEmpty || password.isEmpty) {
        showSnackBar(
          context,
          msg: 'Neither Email nor Password fields should be empty',
        );
        context.pop();
        return;
      }
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        _userRef.doc(email).set({
          'id': _auth.currentUser?.uid,
          'title': user.title,
          'fName': user.fName,
          'lName': user.lName,
          'oName': user.oName,
          'phone': user.phone,
          'admin': email.contains('joshua'),
        });
      }).then(
        (value) {
          context.pop();
          context.go(VerifyEmailScreen.id);
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (context.mounted) {
          showSnackBar(context,
              msg:
                  'The Password you entered is too weak. Create a stronger password.');
        }
        if (context.mounted) {
          context.pop();
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          showSnackBar(context,
              msg:
                  'The Email address you entered is already in use. Log in instead');
        }
        if (context.mounted) {
          context.pop();
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, msg: '${e.message}');
        }
        if (context.mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        context.pop();
      }
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    }
  }

  Future<void> sendPasswordResetLink(
    BuildContext context, {
    required String email,
  }) async {
    showLoadingIndicator(context);
    try {
      if (email.isEmpty) {
        showSnackBar(context, msg: 'Email field cannot be empty');
        context.pop();
        return;
      }
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => context.pop());
      if (context.mounted) {
        showSnackBar(context,
            msg: 'A password reset link has been sent to your email $email');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        context.pop();
      }
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    } catch (e) {
      if (context.mounted) {
        context.pop();
      }
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    showLoadingIndicator(context);
    try {
      await _auth.signOut().then((value) {
        context.pop();
        return;
      });
    } catch (e) {
      if (context.mounted) {
        context.pop();
      }
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    }
  }

  Future<void> sendEmailVerificationLink(BuildContext context) async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, msg: e.toString());
      }
    }
  }
}
