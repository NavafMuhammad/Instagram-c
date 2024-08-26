import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/presentation/signup_screen/signup_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/constants.dart';
import 'package:instagram_flutter/presentation/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: horizontalPadding32,
        width: double.infinity,
        child: Column(
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
            // text field input for email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress),
            kheight24,
            // text field input for password
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Enter your Password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            kheight24,
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: verticalPadding12,
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                child: const Text("Log in"),
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
                  child: const Text("Don't have an account?"),
                ),
                kwidth12,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SignUpScreen()));
                  },
                  child: Container(
                    padding: verticalPadding12,
                    child: const Text(
                      "Sign up",
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
