import 'package:wave_fe/model/Quiz.dart';

class Modules {
  int materiID;
  String title;
  String description;
  String content;
  Quiz? quiz;

  Modules({
    this.quiz,
    required this.materiID,
    required this.title,
    required this.description,
    required this.content,
  });

  // FACTORY
  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      materiID: json['moduleId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      quiz: json['quiz'],
    );
  }
}
