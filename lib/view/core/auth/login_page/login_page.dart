import 'package:flutter/material.dart';
import 'package:wave_fe/view/core/auth/login_page/widget/form_auth_signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    // Kondisi khusus untuk quizId 1 dan questionId 1

    // double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: SizedBox(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child:
                        Image.asset(width: 350, "assets/images/logo_white.png"),
                  )),
                  Expanded(
                    child: FormAuthSignIn(heightScreen: heightScreen),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
