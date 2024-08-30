import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String uid;
  final String email;
  final String bio;
  final List following;
  final List followers;
  final String photoUrl;

  UserModel(
      {required this.userName,
      required this.uid,
      required this.email,
      required this.bio,
      required this.following,
      required this.followers,
      required this.photoUrl});

  Map<String, dynamic> toJson() {
    return {
      "username" : userName,
      "uid" : uid,
      "email" : email,
      "bio" : bio,
      "following" : following,
      "followers" : followers,
      "photoUrl" : photoUrl,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      userName : snap["username"],
      uid : snap["uid"],
      email : snap["email"],
      bio : snap["bio"],
      following : snap["following"],
      followers : snap["followers"],
      photoUrl : snap["photoUrl"],
    );
  }
}
