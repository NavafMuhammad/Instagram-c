import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/presentation/add_posts/add_post_screen.dart';
import 'package:instagram_flutter/presentation/home/home_screen.dart';
import 'package:instagram_flutter/presentation/notiication/notification_screen.dart';
import 'package:instagram_flutter/presentation/profile/profile_screen.dart';
import 'package:instagram_flutter/presentation/search/search_screen.dart';
import 'package:instagram_flutter/responsive/widgets/bottom_navbar.dart';

class MobileScreenLayout extends StatelessWidget {
  MobileScreenLayout({super.key});

  final _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const NotificationScreen(),
     ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
     ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: indexNotifier,
            builder: (BuildContext context, int newIndex, Widget? _) {
              return _pages[newIndex];
            }),
        bottomNavigationBar: const BottomNavBar());
  }
}
