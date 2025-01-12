import 'dart:convert';

import 'package:note_viewer/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class UnitsApi {
  Future<Map<String, dynamic>> addNewUnit({
    required String token,
    required String name,
    required String img,
    required String code,
    required String courseId,
    required String students,
    required String assignments,
    required String semester,
  }) async {
    final url = AppUtils.$baseUrl;

    try {
      final addUnitRequest = await http.post(
        Uri.parse('$url/api/units'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'img': img,
          'code': code,
          'course_id': courseId,
          'students': students,
          'assignments': assignments,
          'semester': semester,
        }),
      );

      return jsonDecode(addUnitRequest.body);
    } catch (e) {
      throw Exception('Failed to add unit $e');
    }
  }
}
