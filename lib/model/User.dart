// ignore: file_names
import 'package:wave_education/model/CourseModel.dart';

class User {
  int userID;
  String? token;
  String name;
  String email;
  List<Course>? courseEnrolled = [];

  User(
      {required this.userID,
      required this.name,
      required this.email,
      this.token,
      this.courseEnrolled});

  // Factory constructor untuk membuat User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['accessToken'],
      userID: json['userId'],
      name: json['fullname'],
      email: json['email'],
      courseEnrolled: json['enrolledCourses'],
    );
  }

  // set enrolledCourses(List<Course> enrolledCourses) {}
}
