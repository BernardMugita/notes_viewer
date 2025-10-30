import 'dart:convert';
import 'package:maktaba/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class CommentsApi {
  final String url = AppUtils.$baseUrl;

  Future<Map<String, dynamic>> createComment({
    required String token,
    required String studyMaterialId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'study_material_id': studyMaterialId,
          'content': content,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<Map<String, dynamic>> getComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/get_comment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'comment_id': commentId,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get comment: $e');
    }
  }

  Future<Map<String, dynamic>> getCommentsByMaterial({
    required String token,
    required String studyMaterialId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/get_by_material'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'study_material_id': studyMaterialId,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get comments by material: $e');
    }
  }

  Future<Map<String, dynamic>> getMyComments({
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/get_my_comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}), // Empty body as per backend route
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get my comments: $e');
    }
  }

  Future<Map<String, dynamic>> editComment({
    required String token,
    required String commentId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'comment_id': commentId,
          'content': content,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to edit comment: $e');
    }
  }

  Future<Map<String, dynamic>> deleteComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url/comments/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'comment_id': commentId,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}
