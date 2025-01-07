import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/controller/ModulesController.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/model/Modules.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';
import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';
import 'package:go_router/go_router.dart';

class CourseDetailPage extends StatelessWidget {
  final String coursePathId;
  const CourseDetailPage({
    required this.coursePathId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final modulesController = Get.put(ModulesController());
    final courseController = Get.put(CourseController());

    if (courseController.course.value == null) {
      courseController.getCourseById(int.parse(coursePathId) + 1);
    }

    int courseId = int.parse(coursePathId) + 1;

    // Safely parse courseId
    int? parsedCourseId;
    try {
      parsedCourseId = int.parse(coursePathId);
    } catch (e) {
      print('Invalid courseId: $coursePathId');
      return const Scaffold(
        body: Center(child: Text('Invalid course ID')),
      );
    }
    // print(userController.user.value?.courseEnrolled?[0]);

    // Fetch modules safely
    modulesController.getModulesOnSpecifiedCourse(parsedCourseId);

    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainHeader(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: SizedBox(
                width: widthScreen,
                child: Obx(() {
                  final enrolledCourses =
                      userController.user.value?.courseEnrolled;
                  // print(enrolledCourses);

                  if (enrolledCourses == null ||
                      parsedCourseId! >= enrolledCourses.length) {
                    return const Center(child: Text('Course not found'));
                  }
                  final coursesDetail = enrolledCourses[parsedCourseId];
                  final moduleEnrolledCourse = coursesDetail.modules;

                  if (modulesController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coursesDetail.title,
                          style: GoogleFonts.poppins(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          coursesDetail.description,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 50),
                        if (moduleEnrolledCourse != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: moduleEnrolledCourse.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ModulesContent(
                                courseId: courseId,
                                module: moduleEnrolledCourse[index],
                                coursePathId: coursePathId,
                                modulePathId: index.toString(),
                              );
                            },
                          ),
                      ],
                    );
                  }
                }),
              ),
            ),
            const MainFooter(),
          ],
        ),
      ),
    );
  }
}

class ModulesContent extends StatelessWidget {
  final String coursePathId;
  final String modulePathId;
  final int courseId;
  final Modules module;

  const ModulesContent({
    required this.courseId,
    required this.module,
    required this.coursePathId,
    required this.modulePathId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final moduleController = Get.put(ModulesController());
    final userController = Get.put(UserController());
    // userController.getUserEnrolledCoursesById();
    // final pointCourse = userController
    //     .user.value?.courseEnrolled?[int.parse(coursePathId)].pointEarned;
    // print(pointCourse);

    return GestureDetector(
      onTap: () async {
        moduleController.getModuleByIdOnSpecifiedCourse(
            userController.user.value!.userID, courseId, module.materiID);

        await Future.delayed(const Duration(seconds: 1));

        if (moduleController.module.value != null) {
          context.goNamed("module", pathParameters: {
            'coursePathId': coursePathId,
            'modulePathId': modulePathId
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return InformationDialog(
                image: 0,
                title: "Cannot open this Module",
                message: "You aren't have enough point.",
              );
            },
          );
          moduleController.getModuleByIdOnSpecifiedCourse(
              userController.user.value!.userID, courseId, module.materiID);
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
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
          color: const Color(0xFF4366DE),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              module.description,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.amber[400],
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       shadowColor: Colors.grey,
            //     ),
            //     onPressed: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) => ConfirmDialog(
            //           title: 'Do you want to Explore this module?',
            //           message:
            //               'use your point to explore this module and do quiz for other module unlocked!',
            //           onConfirm: () async {

            //             if (modulesController.module.value?.materiID != null) {
            //               // context.goNamed(
            //               //   "module",
            //               //   pathParameters: {
            //               //     "courseId": courseId,
            //               //     "moduleId": moduleId,
            //               //   },
            //               // );
            //             } else {
            //               // showDialog(
            //               //     context: context,
            //               //     builder: (context) {
            //               //       return InformationDialog(
            //               //         title: "Oops! Failed to access this module!",
            //               //         message:
            //               //             "Kindly check your point to access this module.",
            //               //       );
            //               //     });
            //             }
            //           },
            //           onCancel: () {
            //             // Handle cancel
            //             Navigator.pop(context);
            //           },
            //         ),
            //       );

            //       // context.goNamed(
            //       //   "module",
            //       //   pathParameters: {
            //       //     "courseId": courseId,
            //       //     "moduleId": moduleId,
            //       //   },
            //       // );
            //     },
            //     child: Text(
            //       'Explore this Course',
            //       style: GoogleFonts.poppins(color: Colors.white),
            //     )),
            // const ButtonApp()
          ],
        ),
      ),
    );
  }
}

class ButtonApp extends StatelessWidget {
  const ButtonApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 170,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Border radius di sini
            ),
            backgroundColor: Colors.amber[400], // Warna background tombol
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12), // Padding tombol
          ),
          onPressed: () {
            context.goNamed("quiz");
          },
          child: Row(
            children: [
              Icon(
                Icons.quiz,
                color: Colors.white,
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Text(
                "Kerjakan Quiz!",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
    );
  }
}
