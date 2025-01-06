import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:wave_fe/controller/UserController.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFDFE9FF),
      title: Container(
        margin: const EdgeInsets.fromLTRB(10, 15, 0, 0),
        width: 180,
        child: Image.asset(
          "assets/images/logo.png",
        ),
      ),
      actions: [
        Obx(
          () => Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 60, 0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    context.goNamed("dashboard");
                  },
                  child: Text(
                    "Dashboard",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF5B5B5B),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed("courses");
                  },
                  child: Text(
                    "Course",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF5B5B5B),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "About Us",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF5B5B5B),
                    ),
                  ),
                ),
                // Foto profile
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    context.goNamed("profile");
                  },
                  child: Row(
                    children: [
                      Container(
                          // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 35,
                          // height: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/avatar.jpg",
                                ),
                                fit: BoxFit.cover),
                          )),
                      const SizedBox(width: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${userController.user.value?.name}",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
