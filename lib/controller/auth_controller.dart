import 'package:firebase_auth/firebase_auth.dart';
import 'package:farmbase/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // rules_version = '2';
  // service cloud.firestore {
  //   match /databases/{database}/documents {
  //     match /users/{userId} {
  //       allow read, write: if request.auth != null && request.auth.uid == userId;
  //     }
  //   }
  // }

  Future<String?> register(UserModel user) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      String uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(uid).set(user.toMap());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw e;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
      // return null;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   return 'No user found for that email.';
      // } else if (e.code == 'wrong-password') {
      //   return 'Wrong password provided for that user.';
      // } else {
      //   return e.message;
      // }
      return null;
    } catch (e) {
      return null;
      // return e.toString();
    }
  }
}
