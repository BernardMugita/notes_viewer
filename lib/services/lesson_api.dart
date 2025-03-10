import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:note_viewer/utils/app_utils.dart';

class LessonApi {
  final url = AppUtils.$baseUrl;

  Future<Map<String, dynamic>> createLesson(
      {required String token,
      required String name,
      required String unitId}) async {
    print(token);
    print(name);
    print(unitId);

    try {
      final createLessonRequest = await http.post(
          Uri.parse('$url/lessons/create'),
          headers: <String, String>{
            // 'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{'name': name, 'unit_id': unitId}));

      print(jsonDecode(createLessonRequest.body));

      return jsonDecode(createLessonRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getLessons(
      {required String token, required String lessonId}) async {
    try {
      final getLessonsRequest =
          await http.post(Uri.parse('$url/lessons/get_lesson'),
              headers: <String, String>{
                // 'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode(<String, String>{'lesson_id': lessonId}));

      return jsonDecode(getLessonsRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getAllLessons(
      {required String token, required String unitId}) async {
    try {
      final getAllLessonsRequest =
          await http.post(Uri.parse('$url/lessons/get_all_lessons'),
              headers: <String, String>{
                // 'Content-Type': 'application/json',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode(<String, String>{'unit_id': unitId}));

      return jsonDecode(getAllLessonsRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }
}
