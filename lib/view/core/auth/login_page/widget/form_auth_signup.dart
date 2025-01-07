import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/widgets/form_attribute.dart';
import 'package:go_router/go_router.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';

class FormAuthSignIn extends StatelessWidget {
  const FormAuthSignIn({
    super.key,
    required this.heightScreen,
  });

  final double heightScreen;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final userController = Get.put(UserController());
    return Container(
      width: 300,
      child: Center(
        child: Container(
          width: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xFFD4E1FF),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Membuat tinggi sesuai konten

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Welcome to ",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    // const Spacer(),
                    Image.asset(
                      "assets/images/logo.png",
                      width: 110,
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text("Sign In",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    )),
                const SizedBox(height: 13),
                FormAttribute(
                  title: "Email",
                  controller: emailController,
                  hintText: "Enter your email",
                  isObsecure: false,
                ),
                const SizedBox(height: 13),
                FormAttribute(
                  controller: passwordController,
                  title: "Password",
                  hintText: "Enter your password",
                  isObsecure: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: const Color(0xFF2D59AF),
                      ),
                      onPressed: userController.isLoading.value
                          ? null
                          : () async {
                              final success = await userController.loginUser(
                                emailController.text,
                                passwordController.text,
                              );

                              if (success) {
                                context.goNamed(
                                    'dashboard'); // Navigate to dashboard
                              } else {
                                showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  builder: (context) => InformationDialog(
                                    image: 0,
                                    title: "Login Failed",
                                    message:
                                        "Please Email or password is incorrect",
                                  ),
                                );
                              }
                            },
                      child: userController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Sign In",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: heightScreen * 0.02),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                      onTap: () => context.goNamed('signup'),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2D59AF),
                        ),
                      ))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
