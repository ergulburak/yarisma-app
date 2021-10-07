import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User _user;

  String? getUser() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return "User null";
      } else {
        return user.displayName;
      }
    } catch (e) {
      print("Failed to gerUser()\n " + e.toString());
      return "Failed to gerUser()";
    }
  }

  Future<bool> isLoggedIn() async {
    var result = false;
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null)
        result = false;
      else
        result = true;
    });
    return result;
  }

  Future<bool> createUser(String nickname, String email, String pass) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      _user = (_firebaseAuth.currentUser)!;
      updateProfile(
        displayName: nickname,
        email: email,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signIn(String email, String pass) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);

      _user = (_firebaseAuth.currentUser)!;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> recovery(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateProfile({
    required String displayName,
    required String email,
  }) async {
    await _user.updateDisplayName(displayName);
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    globals.userData = new UserData(
        uid: _user.uid,
        nickname: displayName,
        mailAdress: email,
        allTrueAnswers: 0,
        allWrongAnswers: 0,
        tickets: 1,
        joker: 1,
        rank: "user",
        totalScore: 0,
        weekScore: 0,
        ticketAdCounter: 0,
        lastWeek: "0");
    users.doc(_user.uid).set(globals.userData!.toJson());
    globals.userCollectionID = _user.uid;
  }
}
