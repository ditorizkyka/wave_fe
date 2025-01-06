import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wave_education/model/Question.dart';
import 'package:wave_education/model/Quiz.dart';

class Quizcontroller extends GetxController {
  Rx<Quiz?> quiz = Rx<Quiz?>(null);

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
        for (int i = 0; i < data.length; i++) {
          Question question = Question.fromJson(data['questionDTO'][i]);
          questionQuiz.add(question);
        }
        quiz.value?.question = questionQuiz;
        quiz.value?.materiID = moduleId;
        quiz.value = quizModule;

        print(
            'Quiz loaded with ${quiz.value?.question?.length ?? 0} questions');
        print('Questions: ${quiz.value?.question}');

        // print(quiz.value?.question);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> submitQuiz() {}
}
