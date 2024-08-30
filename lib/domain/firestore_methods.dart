import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_flutter/domain/models/posts_model.dart';
import 'package:instagram_flutter/domain/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error Occured";
    try {
      String postsUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      PostsModel post = PostsModel(
        description: description,
        uid: uid,
        username: username,
        postID: postId,
        datePublished: DateTime.now(),
        postUrl: postsUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
      return res;
    } catch (err) {
      res = err.toString();
      return res;
    }
  }
}
