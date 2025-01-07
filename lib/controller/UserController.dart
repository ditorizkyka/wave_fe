// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_fe/model/CourseModel.dart';
import 'package:wave_fe/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart'; // Import GetX

class UserController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  // Rx<List?> enrolledCourses = Rx<List?>(null);

  RxBool isLoading = false.obs;

  Future<void> getUserById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';
    String token = prefs.getString('userToken') ?? '';
    try {
      isLoading.value = true;
      final response = await http
          .get(Uri.parse('http://192.168.56.1:8080/api/users/$uid'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 302) {
        Map<String, dynamic> data = jsonDecode(response.body);
        print("data : $data");
        user.value = User.fromJson(data);
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserEnrolledCoursesById() async {
    final userController = Get.put(UserController());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    String uid = prefs.getString('uid') ?? '';

    try {
      final response = await http.get(
          Uri.parse(
            "http://192.168.56.1:8080/api/users/$uid/courses",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 302) {
        List<dynamic> data = jsonDecode(response.body);
        List<Course> courses =
            data.map((data) => Course.fromJson(data['courseDTO'])).toList();

        if (courses.length == data.length) {
          for (int i = 0; i < courses.length; i++) {
            courses[i].pointEarned = data[i]["totalPointEarned"];
          }
        }

        user.value?.courseEnrolled = courses;
      } else {
        print(
            'Failed to load user data: ${response.statusCode} + ${response.body} + is token exist ${userController.user.value?.token}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<http.Response> enrollCourse(int courseId) async {
    final userController = Get.put(UserController());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    // print("object : ${userController.user.value?.name}");
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:8080/api/users/enroll'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}' // Menambahkan token ke header
        },
        body: jsonEncode({
          'courseId': courseId,
          'userId': userController.user.value?.userID
        }),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  RxString errorMessage = ''.obs;

  Future<bool> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Email and password cannot be empty';
        return false;
      }

      // if (!GetUtils.isEmail(email)) {userController
      //   print("error?");
      //   errorMessage.value = 'Please enter a valid email';
      //   return false;
      // }

      final response = await http.post(
        Uri.parse('http://192.168.56.1:8080/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = User.fromJson(data['userDTO']);
        user.value?.token = data['accessToken'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', data['accessToken']);
        await prefs.setString('uid', user.value!.userID.toString());

        return true;
      } else {
        print("halo");
        errorMessage.value = 'Invalid email or password';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please try again.';
      return false;
    } finally {
      print("error?");
      isLoading.value = false;
    }
  }

  Future<http.Response> register(
      String fullname, String email, String password) async {
    // Menyiapkan data user
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:8080/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'fullname': fullname, 'email': email, 'password': password}),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    user.value = null;
  }

  Future<http.Response> updateUser(int userId, String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken') ?? '';
    try {
      isLoading.value = true;
      final response = await http.put(
        Uri.parse('http://192.168.56.1:8080/api/users/edit-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'userId': userId,
          'fullname': fullName,
        }),
      );
      isLoading.value = false;
      return response;
    } catch (e) {
      throw Exception('Failed to update fullName: $e');
    }
  }
}
