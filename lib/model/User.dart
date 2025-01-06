// ignore: file_names
import 'package:wave_fe/model/CourseModel.dart';

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['accessToken'],
      userID: json['userId'],
      name: json['fullname'],
      email: json['email'],
      courseEnrolled: json['enrolledCourses'],
    );
  }
}
