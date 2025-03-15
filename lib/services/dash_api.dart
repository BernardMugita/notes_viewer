import 'dart:convert';

import 'package:maktaba/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class DashApi {
  String url = AppUtils.$baseUrl;

  Future<Map<String, dynamic>> getDashData({required String token}) async {
    try {
      final dashDataRequest = await http
          .post(Uri.parse("$url/data/dashboard"), headers: <String, String>{
        'Content-Type': 'application/json;',
        'Authorization': 'Bearer $token',
      });

      return jsonDecode(dashDataRequest.body);
    } catch (e) {
      throw Exception('Error fetching dash data $e');
    }
  }
}
