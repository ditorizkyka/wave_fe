import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/controller/ModulesController.dart';
import 'package:wave_fe/controller/QuestionController.dart';
import 'package:wave_fe/controller/QuizController.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/model/Modules.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';
import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';
import 'package:wave_fe/view/widgets/show_dialog.dart';

class ModuleDetailPage extends StatelessWidget {
  final String courseId;
  final String moduleId;

  const ModuleDetailPage({
    required this.courseId,
    required this.moduleId,
    super.key,
  });

  Future<String> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final moduleController = Get.put(ModulesController());
    final userController = Get.put(UserController());
    final courseController = Get.put(CourseController());

    courseController.getCourseById(int.parse(courseId) + 1);

    print("user nya ada : ${userController.user.value?.userID}");
    print(
        "usernya punya course ini : ${courseController.course.value?.courseID}");

    final questionController = Get.put(QuestionController());
    final quizController = Get.put(Quizcontroller());

    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainHeader(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Wrap the module details in Obx
              Obx(() {
                // Access the reactive module variable directly
                Modules? module = moduleController.module.value;

                if (module == null) {
                  // Show a loading indicator while the module is being fetched
                  moduleController.getModuleByIdOnSpecifiedCourse(
                    userController.user.value?.userID ?? 0,
                    int.parse(courseId),
                    int.parse(moduleId),
                  );

                  return const Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Fetch quiz for the module
                // Ideally, this should be handled inside the controller to avoid multiple calls
                quizController.getQuizOnSpecifiedModule(module.materiID);
                // print(quizController.quiz.value?.question?[0].questionText);

                return Padding(
                  padding: const EdgeInsets.all(50),
                  child: SizedBox(
                    width: widthScreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: GoogleFonts.poppins(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          module.description,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                          decoration: BoxDecoration(
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
                                "Read this module",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                module.content,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
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
                                        title:
                                            'Do you want to Explore this module?',
                                        message:
                                            'use your point to explore this module and do quiz for other module unlocked!',
                                        onConfirm: () async {
                                          if (quizController.quiz.value !=
                                              null) {
                                            context.goNamed("quiz",
                                                pathParameters: {
                                                  "coursePathId": courseId,
                                                  "questionPathId": "0",
                                                  "modulePathId": moduleId,
                                                });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return InformationDialog(
                                                  title:
                                                      "Cannot open this quiz",
                                                  message: "Eror occured",
                                                );
                                              },
                                            );
                                          }
                                        },
                                        onCancel: () {
                                          // Handle cancel
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );

                                    // context.goNamed(
                                    //   "module",
                                    //   pathParameters: {
                                    //     "courseId": courseId,
                                    //     "moduleId": moduleId,
                                    //   },
                                    // );
                                  },
                                  child: Text(
                                    'Quiz',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
              const MainFooter(),
            ],
          ),
        ));
  }
}
