import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/core/dashboard/dashboard_page.dart';
import 'package:wave_fe/view/core/dashboard/widget/enrolling_card.dart';
import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final courseController = Get.put(CourseController());
    courseController.getAllCourse();
    userController.getUserById();
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainHeader(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopCourses(
                widthScreen: widthScreen, courseController: courseController),
            const Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [SizedBox(height: 20), SectionEnrolledCourse()],
                )),
            SizedBox(height: 50),
            MainFooter()
          ],
        ),
      ),
    );
  }
}

class TopCourses extends StatelessWidget {
  final CourseController courseController;
  const TopCourses({
    required this.courseController,
    super.key,
    required this.widthScreen,
  });

  final double widthScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthScreen,
      // height: 460,
      color: const Color(0xFF4366DE),
      child: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top 3 Popular Courses!",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Jumlah kolom dalam grid
                crossAxisSpacing: 10, // Jarak antar kolom
                mainAxisSpacing: 10, // Jarak antar baris
              ),
              itemCount: courseController.courseList.value?.length ??
                  0, // Jumlah total item yang akan ditampilkan
              itemBuilder: (BuildContext context, int index) {
                final course = courseController.courseList
                    .value?[index]; // Mengakses elemen berdasarkan index
                if (course == null) {
                  return const SizedBox
                      .shrink(); // Jika null, tampilkan widget kosong
                }
                return EnrollingCard(
                  disableButton: true,
                  image: index % 2 == 0
                      ? 'assets/images/genap.png' // Gambar untuk indeks genap
                      : 'assets/images/ganjil.png',
                  courseId: course['courseId'],
                  courseName: course['title'],
                  courseDesc: course['description'],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class PopularCourseCard extends StatelessWidget {
  const PopularCourseCard({
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
      height: 290,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80"),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Pemrograman Web",
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipising elit, sed do eiusmod tempor",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
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
                ),
              ),
              title: Text(
                "Ghefin",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: SizedBox(
                width: 50,
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber[600],
                    ),
                    Text(
                      "4.5",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
