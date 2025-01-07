import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';
import 'package:wave_fe/view/widgets/show_dialog.dart';

// ignore: must_be_immutable
class EnrollingCard extends StatelessWidget {
  int? courseId;
  String? courseName;
  String? courseDesc;
  String image;
  bool disableButton;

  EnrollingCard({
    required this.disableButton,
    required this.image,
    this.courseId,
    this.courseDesc,
    this.courseName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // elevation
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 6,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      width: 350,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              courseName ?? "null",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              courseDesc ?? "null",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              maxLines: 3, // Batas maksimal 3 baris
              overflow: TextOverflow
                  .ellipsis, // Menampilkan '...' di akhir jika teks terlalu panjang
            ),
            const SizedBox(height: 10),
            ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                    // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: 35,
                    // height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80"),
                          fit: BoxFit.cover),
                    )),
                title: Text("Admin", style: GoogleFonts.poppins(fontSize: 12)),
                trailing: disableButton
                    ? null
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.grey,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                              buttonText: "Enroll",
                              title: 'Enroll Course',
                              message: 'Do you want to enroll in this course?',
                              onConfirm: () async {
                                final userController =
                                    Get.put(UserController());
                                final response = await userController
                                    .enrollCourse(courseId ?? 0);
                                userController.getUserEnrolledCoursesById();

                                if (response.statusCode == 200) {
                                  Navigator.pop(context);
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
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Enrollment failed: ${response.body}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  Navigator.pop(context); // Tutup dialog
                                }
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        child: const Text("Enroll",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      )),
          ],
        ),
      ),
    );
  }
}

class ContainerNews extends StatelessWidget {
  const ContainerNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFD4E1FF),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Tren Penggunaan Bahasa Pemrograman Tahun Ini",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4366DE),
                )),
            const SizedBox(height: 20),
            Text(
                "JavaScript (JS) menduduki posisi teratas dengan 62.3% pengguna, menjadikannya bahasa pemrograman paling banyak digunakan.\n\n HTML/CSS mengikuti dengan 52.9%, yang mendukung pengembangan front-end dan desain web.",
                style: GoogleFonts.poppins(fontSize: 21)),
          ]),
        ),
      ),
    );
  }
}
