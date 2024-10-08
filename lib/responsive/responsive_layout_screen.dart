import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_flutter/application/providers/user_provider.dart';
import 'package:instagram_flutter/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth > webScreenSize) {
        //web screen
        log("webscreen");
        return widget.webScreenLayout;
      } else {
        //mobile screen
        log("mobilescreen");

        return widget.mobileScreenLayout;
      }
    });
  }
}
