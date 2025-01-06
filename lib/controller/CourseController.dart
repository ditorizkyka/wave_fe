import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:wave_fe/model/CourseModel.dart';

class CourseController extends GetxController {
  Rx<List<dynamic>?> courseList = Rx<List<dynamic>?>(null); // List<Course>
  Rx<Course?> course = Rx<Course?>(null);
  Rx<int?> courseLength = Rx<int?>(null);

  RxBool isLoading = false.obs;
  Future<void> getAllCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    try {
      isLoading.value = true;
      final response = await http
          .get(Uri.parse('http://192.168.56.1:8080/api/courses/all'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}'
      });

      if (response.statusCode == 302) {
        List<dynamic> data = jsonDecode(response.body);
        courseLength.value = data.length;
        courseList.value = data;
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCourseById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    try {
      isLoading.value = true;
      final response = await http.get(
          Uri.parse('http://192.168.56.1:8080/api/courses/${id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 302) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Course courseData = Course.fromJson(data);
        course.value = courseData;
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
