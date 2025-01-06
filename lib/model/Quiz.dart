import 'package:flutter/foundation.dart';

class Quiz {
  int quizID;
  int? materiID;
  int rewardPoints;
  List<Question>? question = [];

  Quiz(
      {required this.quizID,
      this.materiID,
      required this.rewardPoints,
      this.question});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizID: json['quizId'],
      rewardPoints: json['rewardPoint'],
    );
  }
}
