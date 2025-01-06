import 'package:flutter/material.dart';
import 'package:wave_fe/view/core/auth/signup/widget/form_auth_signup.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
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
                    child: FormAuthSignUp(heightScreen: heightScreen),
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
