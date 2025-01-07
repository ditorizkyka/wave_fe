import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/core/dashboard/widget/course_card.dart';
import 'package:wave_fe/view/core/dashboard/widget/enrolling_card.dart';
import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final courseController = Get.put(CourseController());
    courseController.getAllCourse();
    userController.getUserById();

    // print(courseController.course.value);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainHeader(),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => SafeArea(
              child: userController.isLoading.value == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(
                            child: SizedBox(
                              // height: 8000,
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello, ${userController.user.value?.name}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 50),
                                  const SectionEnrolledCourse(),
                                  const SizedBox(height: 50),
                                  const SectionEnrollCourse(),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                        MainFooter(),
                      ],
                    )),
        ),
      ),
    );
  }
}

class SectionEnrollCourse extends StatelessWidget {
  const SectionEnrollCourse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController());
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Courses",
            style:
                GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 50),
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
                disableButton: false,
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
    );
  }
}

class SectionEnrolledCourse extends StatelessWidget {
  const SectionEnrolledCourse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    userController.getUserEnrolledCoursesById();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Courses",
          style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 50),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Jumlah kolom dalam grid
            crossAxisSpacing: 10, // Jarak antar kolom
            mainAxisSpacing: 10, // Jarak antar baris
          ),
          itemCount: userController.user.value?.courseEnrolled?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return CoursesCard(
              image: index % 2 == 0
                  ? 'assets/images/genap.png' // Gambar untuk indeks genap
                  : 'assets/images/ganjil.png', // Gambar untuk indeks ganjil
              course: userController.user.value?.courseEnrolled?[index],
              coursePathId: index,
            );
          },
        )
      ],
    );
  }
}
