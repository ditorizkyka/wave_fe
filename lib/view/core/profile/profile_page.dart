import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/widgets/form_attribute.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';
import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';
import 'package:wave_fe/view/widgets/show_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    TextEditingController fullnameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: double.infinity,
                        height: const Size.fromHeight(100).height,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFF4EADA), Color(0xffDFE9FF)],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        width: double.infinity,
                        // color: Colors.red,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/avatar.jpg",
                              ),
                              radius: 60,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userController.user.value?.name}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "${userController.user.value?.email}",
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade400,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                // width: 200,
                                height: 100,
                                child: FormAttribute(
                                    controller: fullnameController,
                                    title: "Full Name",
                                    hintText: "Change your name here!",
                                    isObsecure: false),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 90),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                      backgroundColor: const Color(0xFF4366DE),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmDialog(
                                        buttonText: "Save",
                                        title: 'Save changes?',
                                        message:
                                            'Proceed to save changes to your profile?',
                                        onConfirm: () async {
                                          final response =
                                              await userController.updateUser(
                                                  userController
                                                      .user.value!.userID,
                                                  fullnameController.text);

                                          if (response.statusCode == 200) {
                                            Navigator.pop(context);
                                            // Tutup dialog
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return InformationDialog(
                                                    image: 1,
                                                    title: "Success",
                                                    message:
                                                        "You have successfully enrolled in the course.",
                                                  );
                                                });

                                            // Lakukan refresh halaman
                                          } else {
                                            // Gagal, tampilkan pesan error
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Enrollment failed: ${response.body}"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            Navigator.pop(
                                                context); // Tutup dialog
                                          }
                                        },
                                        onCancel: () {
                                          // Handle cancel
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            onPressed: () {
                              final userController = Get.put(UserController());
                              userController.logout();
                              context.goNamed("login");
                            },
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                const MainFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
