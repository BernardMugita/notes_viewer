import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final dio = Dio();

  Future<Map<String, dynamic>> signIN(
      {required String email, required String password}) async {
    try {
      final String url = '${AppUtils.$baseUrl}/users/login';

      final signInRequest = await http.post(Uri.parse(url),
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }));

      return jsonDecode(signInRequest.body) as Map<String, dynamic>;
    } on DioException catch (e) {
      return {
        'error': 'Failed to sign in: ${e.message}',
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'error': 'Failed to sign in: $e',
        'statusCode': 500,
      };
    }
  }

  Future<Map<String, dynamic>> signUp(
      {required String username,
      required String email,
      required String password,
      required String phone,
      required String regNo,
      required String image}) async {
    try {
      final String url = '${AppUtils.$baseUrl}/users/create';

      final signUpRequest = await http.post(Uri.parse(url),
          body: jsonEncode(<String, String>{
            'username': username,
            'email': email,
            'password': password,
            'phone': phone,
            'reg_no': regNo,
            'img': image
          }));
      return jsonDecode(signUpRequest.body) as Map<String, dynamic>;
    } on DioException catch (e) {
      return {
        'error': 'Failed to sign up: ${e.message}',
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'error': 'Failed to sign up: $e',
        'statusCode': 500,
      };
    }
  }

  Future<Map<String, dynamic>> updateStudentCourse(
      {required String token, required String courseId}) async {
    try {
      final String url = '${AppUtils.$baseUrl}/users/update_course';

      final updateCourseRequest = await http.post(Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
          body: jsonEncode(<String, String>{'course_id': courseId}));
      return jsonDecode(updateCourseRequest.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'error': 'Failed to update course: $e',
        'statusCode': 500,
      };
    }
  }
}
