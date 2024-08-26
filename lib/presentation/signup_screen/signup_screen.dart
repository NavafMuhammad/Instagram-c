import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/domain/auth_methods.dart';
import 'package:instagram_flutter/presentation/home/home_screen.dart';
import 'package:instagram_flutter/presentation/login_screen/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/constants.dart';
import 'package:instagram_flutter/presentation/widgets/text_field_input.dart';
import 'package:instagram_flutter/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List?  _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      username: _userNameController.text,
      password: _passwordController.text,
      bio: _bioController.text,
      file: _image!,
    );
    log(res);
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: horizontalPadding32,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1, child: Container()),

            // svg image
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            kheight24,
            // circular widget to accept and show our selected file
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          "https://i.sstatic.net/dr5qp.jpg",
                        ),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        )))
              ],
            ),
            kheight24,
            // text fiel input for user name
            TextFieldInput(
              textEditingController: _userNameController,
              hintText: "Enter your username",
              textInputType: TextInputType.text,
            ),
            kheight24,

            // text field input for email
            TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your Email",
              textInputType: TextInputType.emailAddress,
            ),
            kheight24,
            // text field input for password
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your Password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            kheight24,
            // text field input for bio
            TextFieldInput(
              textEditingController: _bioController,
              hintText: "Enter your bio",
              textInputType: TextInputType.text,
            ),
            kheight24,
            InkWell(
              onTap: () async {
                signUpUser();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: verticalPadding12,
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                child: const Text("Sign up"),
              ),
            ),
            kheight12,
            Flexible(flex: 1, child: Container()),

            // transitioning to signing up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: verticalPadding12,
                  child: const Text("Already have an account?"),
                ),
                kwidth12,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  },
                  child: Container(
                    padding: verticalPadding12,
                    child: const Text(
                      "Log in",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
