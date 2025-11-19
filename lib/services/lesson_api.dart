import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:maktaba/utils/app_utils.dart';

class LessonApi {
  final url = AppUtils.$baseUrl;
  Logger logger = Logger();

  Future<Map<String, dynamic>> createLesson(
      {required String token,
      required String name,
      required String unitId}) async {
    try {
      final createLessonRequest = await http.post(
          Uri.parse('$url/lessons/create'),
          headers: <String, String>{'Authorization': 'Bearer $token'},
          body: jsonEncode(<String, String>{'name': name, 'unit_id': unitId}));

      return jsonDecode(createLessonRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getLessons(
      {required String token, required String lessonId}) async {
    try {
      final getLessonsRequest = await http.post(
          Uri.parse('$url/lessons/get_lesson'),
          headers: <String, String>{'Authorization': 'Bearer $token'},
          body: jsonEncode(<String, String>{'lesson_id': lessonId}));

      return jsonDecode(getLessonsRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> getAllLessons(
      {required String token, required String unitId}) async {
    try {
      final getAllLessonsRequest = await http.post(
          Uri.parse('$url/lessons/get_all_lessons'),
          headers: <String, String>{'Authorization': 'Bearer $token'},
          body: jsonEncode(<String, String>{'unit_id': unitId}));

      return jsonDecode(getAllLessonsRequest.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> deleteLesson(
      {required String token, required String lessonId}) async {
    final url = AppUtils.$baseUrl;

    try {
      final deleteLessonRequest = await http.post(
        Uri.parse('$url/lessons/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'lesson_id': lessonId,
        }),
      );
      return jsonDecode(deleteLessonRequest.body);
    } catch (e) {
      throw Exception('Failed to delete lesson $e');
    }
  }

  Future<Map<String, dynamic>> addLessonSort(
      {required String token,
      required String lessonId,
      required List sortedMaterial}) async {
    final url = AppUtils.$baseUrl;

    try {
      final sortMaterialsRequest = await http.post(
        Uri.parse('$url/lessons/add_sort'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'lesson_id': lessonId,
          'sort': sortedMaterial,
        }),
      );
      return jsonDecode(sortMaterialsRequest.body);
    } catch (e) {
      throw Exception('Failed to sort lesson materials: $e');
    }
  }
}
