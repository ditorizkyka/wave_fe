import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/model/CourseModel.dart';

// ignore: must_be_immutable
class CoursesCard extends StatelessWidget {
  Course? course;
  int? coursePathId;
  String image;

  CoursesCard({
    required this.image,
    required this.course,
    required this.coursePathId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final courseController = Get.put(CourseController());
        courseController.course.value = course;
        context.goNamed("DBCourse",
            pathParameters: {"coursePathId": coursePathId.toString()});
      },
      child: Container(
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
                  height: 900,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                course?.title ?? "null",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                course?.description ?? "null",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
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
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.33, // Nilai progress (0.0 hingga 1.0)
                backgroundColor: Colors.grey[300], // Warna latar belakang
                color: const Color(0xFF49BBBD), // Warna progress
                minHeight: 4, // Tinggi bar
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text("50% Kursus telah selesai",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ),
            ],
          ),
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
        // border radius
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
