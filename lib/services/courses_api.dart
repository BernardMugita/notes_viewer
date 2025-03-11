import 'dart:convert';

import 'package:note_viewer/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class CoursesApi {
  final url = AppUtils.$baseUrl;

  Future<Map<String, dynamic>> getCourse(
      {required String? token, required String id}) async {
    try {
      final getCourseRequest =
          await http.post(Uri.parse('$url/courses/get_course'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, String>{'course_id': id}));

      return jsonDecode(getCourseRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getAllCourses({required String? token}) async {
    try {
      final getAllCourseRequest = await http.post(
        Uri.parse('$url/courses/get_all_courses'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(getAllCourseRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }
}
