import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/domain/models/user_model.dart';
import 'package:instagram_flutter/domain/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user details from Firestore
  Future<UserModel> getUserDetails() async {
    try {
      User currentUser = _auth.currentUser!;

      DocumentSnapshot snapshot = await _firestore.collection("users").doc(currentUser.uid).get();

      if (snapshot.exists) {
        return UserModel.fromSnap(snapshot); // Assuming fromSnap handles deserialization
      } else {
        throw Exception("User not found in Firestore");
      }
    } catch (e) {
      log("Error fetching user details: $e");
      rethrow; // Re-throw the error to be handled upstream
    }
  }

  // Sign up a user
  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      // Validate inputs
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty && bio.isNotEmpty && file.isNotEmpty) {
        // Register the user
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

        // Log UID for debugging
        log("User UID: ${userCred.user!.uid}");

        // Upload profile picture
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // Create a new UserModel object
        UserModel user = UserModel(
          userName: username,
          uid: userCred.user!.uid,
          email: email,
          bio: bio,
          following: [],
          followers: [],
          photoUrl: photoUrl,
        );

        // Save user to Firestore
        await _firestore.collection("users").doc(userCred.user!.uid).set(user.toJson());

        res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (e) {
      log("Sign-up error: $e");
      res = e.toString();
    }
    return res;
  }

  // Login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      // Validate inputs
      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in the user
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all required fields";
      }
    } catch (e) {
      log("Login error: $e");
      res = e.toString();
    }
    return res;
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error signing out: $e");
      throw e;
    }
  }
}
