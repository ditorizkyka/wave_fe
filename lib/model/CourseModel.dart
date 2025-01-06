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

  // Methods
  void setCourseID(int id) {
    courseID = id;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }

  // void setProgress(double progress) {
  //   this.progress = progress;
  // }

  int getCourseID() => courseID;

  String getTitle() => title;

  String getDescription() => description;

  // double getProgress() => progress;

  void startCourse() {
    print("Course '$title' has started!");
  }
}
