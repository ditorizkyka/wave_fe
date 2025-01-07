import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_fe/controller/UserController.dart';
import 'package:wave_fe/model/Modules.dart';

class ModulesController extends GetxController {
  Rx<List<dynamic>?> courseModules = Rx<List<dynamic>?>(null);
  Rx<Modules?> module = Rx<Modules?>(null);
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> getModulesOnSpecifiedCourse(int courseId) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userController = Get.find<UserController>();
      String token = prefs.getString('userToken') ?? '';

      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse(
            'http://192.168.56.1:8080/api/courses/${courseId + 1}/modules'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 302) {
        try {
          List<dynamic> data = jsonDecode(response.body);
          List<Modules> modules =
              data.map((data) => Modules.fromJson(data)).toList();

          if (userController.user.value?.courseEnrolled != null &&
              courseId <
                  (userController.user.value?.courseEnrolled?.length ?? 0)) {
            userController.user.value?.courseEnrolled?[courseId].modules =
                modules;
          } else {
            throw Exception('Invalid course ID or no enrolled courses found');
          }
        } catch (e) {
          throw Exception('Failed to parse module data: $e');
        }
      } else {
        throw Exception(
            'Failed to fetch modules. Status code: ${response.statusCode}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error in getModulesOnSpecifiedCourse: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getModuleByIdOnSpecifiedCourse(
      int userId, int courseId, int moduleId) async {
    hasError.value = false;
    errorMessage.value = '';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken') ?? '';

      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse(
            'http://192.168.56.1:8080/api/courses/users/$userId/courses/$courseId/modules/$moduleId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 302) {
        try {
          Map<String, dynamic> data = jsonDecode(response.body);
          module.value = Modules.fromJson(data);
        } catch (e) {
          throw Exception('Failed to parse module data: $e');
        }
      } else {
        module.value = null;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error in getModuleByIdOnSpecifiedCourse: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasModules =>
      !isLoading.value && !hasError.value && module.value != null;

  void clearState() {
    module.value = null;
    courseModules.value = null;
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
  }
}
