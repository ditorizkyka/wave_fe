import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wave_fe/model/Question.dart';
import 'package:wave_fe/model/Quiz.dart';

class Quizcontroller extends GetxController {
  Rx<Quiz?> quiz = Rx<Quiz?>(null);
  Rx<List<Object>> answers = Rx<List<Object>>([]);
  RxBool isLoading = false.obs;
  Rx<bool?> passed = Rx<bool?>(null);

  Future<void> getQuizOnSpecifiedModule(int moduleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    try {
      final response = await http.get(
          Uri.parse('http://192.168.56.1:8080/api/modules/$moduleId/quiz'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 302) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Quiz quizModule = Quiz.fromJson(data);
        quiz.value = quizModule;
        List<Question> questionQuiz = [];

        for (int i = 0; i < data['questionDTO'].length; i++) {
          Question question = Question.fromJson(data['questionDTO'][i]);
          questionQuiz.add(question);
        }

        quiz.value?.question = questionQuiz;
        quiz.value?.materiID = moduleId;
        quiz.value = quizModule;

        // print(quiz.value?.question);
      }
    } catch (e) {
      print('Errorsss: $e');
    }
  }

  void addAnswer(
      int questionId, String questionType, List<dynamic> optionDTOS) {
    answers.value.add({
      'questionId': questionId,
      'questionType': questionType,
      'optionDTOS': optionDTOS
    });
  }

  Future<void> submitQuiz(
      int userId, int quizId, int courseId, List<dynamic> userAnswers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('http://192.168.56.1:8080/api/modules/quiz/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'userId': userId,
          'quizId': quizId,
          'courseId': courseId,
          'userAnswers': userAnswers
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Ambil nilai 'pass'
        final bool isPass = responseData['pass'];
        passed.value = isPass;
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
