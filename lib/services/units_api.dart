import 'dart:convert';

import 'package:maktaba/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class UnitsApi {
  Future<Map<String, dynamic>> addNewUnit({
    required String token,
    required String name,
    required String img,
    required String code,
    required String courseId,
    required List students,
    required List assignments,
    required String semester,
  }) async {
    final url = AppUtils.$baseUrl;

    try {
      final addUnitRequest = await http.post(
        Uri.parse('$url/units/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
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

  Future<Map<String, dynamic>> getUnit(
      {required String token, required String unitId}) async {
    final url = AppUtils.$baseUrl;

    try {
      final getUnitRequest = await http.post(
        Uri.parse('$url/units/get_user_units'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'unit_id': unitId,
        }),
      );

      return jsonDecode(getUnitRequest.body);
    } catch (e) {
      throw Exception('Failed to get user units $e');
    }
  }

  Future<Map<String, dynamic>> getUserUnits({required String token}) async {
    final url = AppUtils.$baseUrl;

    try {
      final getUserUnitsRequest = await http.post(
        Uri.parse('$url/units/get_user_units'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(getUserUnitsRequest.body);
    } catch (e) {
      throw Exception('Failed to get user units $e');
    }
  }

  Future<Map<String, dynamic>> editUserUnits(
      {required String token, required Map newUnit}) async {
    final url = AppUtils.$baseUrl;

    try {
      final editUserUnitsRequest = await http.post(
        Uri.parse('$url/units/edit_unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'name': newUnit['name'],
          'img': newUnit['img'],
          'code': newUnit['code'],
          'course_id': newUnit['courseId'],
          'students': newUnit['students'],
          'assignments': newUnit['assignments'],
          'semester': newUnit['semester'],
        }),
      );
      return jsonDecode(editUserUnitsRequest.body);
    } catch (e) {
      throw Exception('Failed to get user units $e');
    }
  }

  Future<Map<String, dynamic>> deleteUnit(
      {required String token, required String unitId}) async {
    final url = AppUtils.$baseUrl;

    try {
      final getUserUnitsRequest = await http.post(
        Uri.parse('$url/units/delete_unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'unit_id': unitId,
        }),
      );
      return jsonDecode(getUserUnitsRequest.body);
    } catch (e) {
      throw Exception('Failed to get user units $e');
    }
  }
}
