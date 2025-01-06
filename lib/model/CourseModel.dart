import 'package:wave_fe/model/Modules.dart';

class Course {
  int courseID;
  String title;
  String description;
  int? pointEarned;
  List<Modules>? modules = [];

  Course({
    required this.courseID,
    required this.title,
    required this.description,
    // required this.progress,
    this.pointEarned,
    this.modules,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseID: json['courseId'],
      title: json['title'],
      description: json['description'],
      modules: json['modules'],
    );
  }
}
