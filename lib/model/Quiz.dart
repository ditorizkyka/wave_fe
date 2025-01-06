import 'package:flutter/foundation.dart';
import 'package:wave_fe/model/Question.dart';
import 'package:wave_fe/model/Scoreable.dart';

class Quiz implements Scoreable {
  int quizID;
  int? materiID;
  int rewardPoints;
  List<Question>? question = [];

  Quiz(
      {required this.quizID,
      this.materiID,
      required this.rewardPoints,
      this.question});

  @override
  int calculateScore() {
    return 0;
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizID: json['quizId'],
      rewardPoints: json['rewardPoint'],
    );
  }
}
