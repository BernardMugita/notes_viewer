import 'dart:convert';

import 'package:note_viewer/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<Map<String, dynamic>> getUser({required String token}) async {
    final url = AppUtils.$baseUrl;

    try {
      final getUserRequest = await http.post(
        Uri.parse('$url/users/get_user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      return jsonDecode(getUserRequest.body);
    } catch (e) {
      throw Exception('Failed to get user details $e');
    }
  }

  Future<Map<String, dynamic>> editUser(
      {required String token,
      required String username,
      required String email,
      required String image,
      required String phone}) async {
    final url = AppUtils.$baseUrl;

    try {
      final editUserRequest = await http.post(Uri.parse('$url/users/edit'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'email': email,
            'image': image,
            'phone': phone,
          }));

      print(editUserRequest.body);

      return jsonDecode(editUserRequest.body);
    } catch (e) {
      throw Exception('Failed to edit user details $e');
    }
  }
}
