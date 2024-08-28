import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/domain/models/user_model.dart';
import 'package:instagram_flutter/domain/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot = await _firestore.collection("users").doc(currentUser.uid).get();

    return UserModel.fromSnap(snapshot);
  }

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
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        _auth.setLanguageCode('en');
        //register the user
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to database
        log(userCred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        UserModel user = UserModel(
            userName: username,
            uid: userCred.user!.uid,
            email: email,
            bio: bio,
            following: [],
            followers: [],
            photoUrl: photoUrl);

        await _firestore
            .collection("users")
            .doc(userCred.user!.uid)
            .set(user.toJson());

        return res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      return res = err.toString();
    }
    return res;
  }

  // login user

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        return res = "success";
      } else {
        res = "Please enter all the required fields";
      }
    } catch (err) {
      log(err.toString());
    }
    return res;
  }
}
