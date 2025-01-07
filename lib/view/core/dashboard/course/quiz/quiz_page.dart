import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wave_fe/controller/CourseController.dart';
import 'package:wave_fe/controller/ModulesController.dart';
import 'package:wave_fe/controller/QuestionController.dart';
import 'package:wave_fe/controller/QuizController.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/view/widgets/information_dialog.dart';

import 'package:wave_fe/view/widgets/main_footer.dart';
import 'package:wave_fe/view/widgets/main_header.dart';
import 'package:wave_fe/view/widgets/show_dialog.dart';

class QuizPage extends StatelessWidget {
  final String? questionPathId;
  final String modulePathId;
  final String coursePathId;
  final String? nextQuestion;

  QuizPage({
    required this.coursePathId,
    required this.modulePathId,
    this.questionPathId,
    this.nextQuestion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int currentQuestionId = int.tryParse(questionPathId ?? "1") ?? 1;
    final questionController = Get.put(QuestionController());
    final quizController = Get.put(Quizcontroller());
    final courseController = Get.put(CourseController());
    final question = quizController.quiz.value?.question?[currentQuestionId];

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
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quiz Page",
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Question ${currentQuestionId + 1}",
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF4366DE),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionQuiz(
                                    text: question?.questionText ??
                                        "Cannot Load this Question"),
                                if (question?.questionType == "SINGLE_CHOICE")
                                  Container(
                                      child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: question?.option?.length,
                                    itemBuilder: (context, index) {
                                      return Obx(
                                        () => RadioListTile(
                                          activeColor: const Color(0xFF4366DE),
                                          title: Text(question
                                                  ?.option?[index].optionText ??
                                              "Cannot Load this Option"),
                                          value: question
                                              ?.option?[index].optionText,
                                          groupValue: questionController
                                              .selectedSingleAnswer.value,
                                          onChanged: (value) {
                                            questionController
                                                .selectedSingleAnswer
                                                .value = value.toString();

                                            questionController
                                                .singleAnswerObject.value = {
                                              'optionId': question
                                                  ?.option?[index].optionId,
                                              'options': value.toString()
                                            };
                                          },
                                        ),
                                      );
                                    },
                                  ))
                                else if (question?.questionType ==
                                    "MULTIPLE_CHOICE")
                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: question?.option?.length,
                                      itemBuilder: (context, index) {
                                        final option =
                                            question?.option?[index].optionText;

                                        return Obx(
                                          () => CheckboxListTile(
                                            activeColor:
                                                const Color(0xFF4366DE),
                                            title: Text(question?.option?[index]
                                                    .optionText ??
                                                "Cannot Load this Option"),
                                            value: questionController
                                                .isOptionSelected(question
                                                        ?.option?[index]
                                                        .optionText ??
                                                    ""),
                                            onChanged: (bool? selected) {
                                              if (selected != null) {
                                                questionController
                                                    .updateMultipleSelection(
                                                        question!.option![index]
                                                            .optionId,
                                                        option!,
                                                        selected);
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
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
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "Question",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List.generate(5, (index) {
                                          return RemainingQuestion(
                                            number: (index + 1).toString(),
                                            isSelected: currentQuestionId + 1 ==
                                                (index + 1),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (question?.questionType ==
                                            "SINGLE_CHOICE") {
                                          quizController.addAnswer(
                                              question?.questionId ?? 1,
                                              question?.questionType ??
                                                  "SINGLE_CHOICE",
                                              [
                                                questionController
                                                    .singleAnswerObject.value
                                              ]);
                                        } else if (question?.questionType ==
                                            "MULTIPLE_CHOICE") {
                                          quizController.addAnswer(
                                              question?.questionId ?? 1,
                                              question?.questionType ??
                                                  "MULTIPLE_CHOICE",
                                              questionController
                                                  .multipleAnswerObject.value);

                                          questionController
                                              .multipleAnswerObject.value = [];
                                        }
                                        String nextQuestion =
                                            (currentQuestionId + 1).toString();

                                        if (nextQuestion == '5') {
                                          print(
                                              "JAWABAN : ${quizController.answers.value}");
                                          final userController =
                                              Get.put(UserController());

                                          showDialog(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                              buttonText: "Submit",
                                              title: 'Submit Quiz?',
                                              message:
                                                  'Are you sure you want to submit this quiz?',
                                              onConfirm: () {
                                                quizController.submitQuiz(
                                                    userController
                                                        .user.value!.userID,
                                                    quizController
                                                        .quiz.value!.quizID,
                                                    courseController
                                                        .course.value!.courseID,
                                                    quizController
                                                        .answers.value);

                                                quizController.answers.value =
                                                    [];
                                                questionController
                                                    .multipleAnswerObject
                                                    .value = [];
                                                questionController
                                                    .selectedSingleAnswer
                                                    .value = '';
                                                questionController
                                                    .selectedMultipleValues
                                                    .value = [];

                                                context.goNamed("DBCourse",
                                                    pathParameters: {
                                                      "coursePathId":
                                                          coursePathId
                                                              .toString()
                                                    });
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        } else {
                                          context
                                              .goNamed("quiz", pathParameters: {
                                            "questionPathId": nextQuestion,
                                            "modulePathId": modulePathId,
                                            "coursePathId": coursePathId
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 20),
                                        backgroundColor:
                                            const Color(0xFFDFE9FF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        shadowColor: Colors.grey,
                                      ),
                                      child: const Text("Next"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const MainFooter(),
          ],
        ),
      ),
    );
  }
}

class ButtonQuiz extends StatelessWidget {
  final String questionPathId;
  final String modulePathId;
  final String coursePathId;
  final String text;
  const ButtonQuiz({
    required this.questionPathId,
    required this.modulePathId,
    required this.coursePathId,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.goNamed("quiz", pathParameters: {
          "questionPathId": "${int.parse(questionPathId) + 1}",
          "modulePathId": modulePathId,
          "coursePathId": coursePathId
        });
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: const Color(0xFFDFE9FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.grey,
      ),
    );
  }
}

class RemainingQuestion extends StatelessWidget {
  final String number;
  final bool isSelected;

  const RemainingQuestion({
    required this.isSelected,
    required this.number,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : const Color(0xFFDFE9FF),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          number,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class QuestionQuiz extends StatelessWidget {
  final String text;
  const QuestionQuiz({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
      child: Text(
        text ?? "Cannot Load this Question",
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class ChoicesQuiz extends StatelessWidget {
  const ChoicesQuiz({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          backgroundColor: const Color(0xFFDFE9FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          shadowColor: Colors.grey,
        ),
        onPressed: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Answer 1",
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
