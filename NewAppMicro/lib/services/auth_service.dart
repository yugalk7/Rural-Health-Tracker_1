import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create AppUser object based on Firebase User
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in with email & password
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Register with email & password
  Future<dynamic> registerWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Create a new document for the user with the uid and role
        await DatabaseService(uid: user.uid).updateUserData(role, email);
        return _userFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return;
    }
  }
}

