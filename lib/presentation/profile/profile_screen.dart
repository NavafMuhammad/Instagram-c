import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/presentation/widgets/follow_button.dart';
import 'package:instagram_flutter/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followersLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      followersLen = userSnap.data()!["followers"].length;
      followingLen = userSnap.data()!["followers"].length;
      userData = userSnap.data()!;
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["username"]),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData["photoUrl"]),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    StatColumnWidget(
                                      num: postLen,
                                      text: "Posts",
                                    ),
                                    StatColumnWidget(
                                      num: followersLen,
                                      text: "Followers",
                                    ),
                                    StatColumnWidget(
                                      num: followingLen,
                                      text: "Following",
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            function: () {},
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: "Edit Profile",
                                            textColor: primaryColor,
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                function: () {},
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: Colors.grey,
                                                text: "Unfollow",
                                                textColor: primaryColor,
                                              )
                                            : FollowButton(
                                                function: () {},
                                                backgroundColor: blueColor,
                                                borderColor: blueColor,
                                                text: "Follow",
                                                textColor: primaryColor,
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userData["username"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          userData["bio"],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                )
              ],
            ));
  }
}

class StatColumnWidget extends StatelessWidget {
  final int num;
  final String text;
  const StatColumnWidget({
    super.key,
    required this.num,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ],
    );
  }
}
