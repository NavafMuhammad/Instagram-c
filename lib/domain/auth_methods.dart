import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/domain/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// to sign up user
  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        _auth.setLanguageCode('en');
        //register the user
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to database
        log(userCred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        await _firestore.collection("users").doc(userCred.user!.uid).set({
          "username": username,
          "uid": userCred.user!.uid,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          "photoUrl" : photoUrl,
        });

        return res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      return res = err.toString();
    }
    return res;
  }
}
