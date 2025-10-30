import 'package:flutter/material.dart';
import 'package:maktaba/services/comments_api.dart';

class CommentsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';
  List<dynamic> comments = [];
  String owner = '';
  Map<String, dynamic>? commentToEdit;

  CommentsApi commentsApi = CommentsApi();

  void setCommentToEdit(Map<String, dynamic>? comment) {
    commentToEdit = comment;
    notifyListeners();
  }

  Future<bool> createComment({
    required String token,
    required String studyMaterialId,
    required String content,
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await commentsApi.createComment(
        token: token,
        studyMaterialId: studyMaterialId,
        content: content,
      );

      if (response['status'] == 'success') {
        success = true;
        message = "Comment created successfully!";
        // Optionally refresh comments for the material
        await getCommentsByMaterial(token: token, studyMaterialId: studyMaterialId);
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to create comment.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error creating comment: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getComment({
    required String token,
    required String commentId,
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await commentsApi.getComment(
        token: token,
        commentId: commentId,
      );

      if (response['status'] == 'success') {
        success = true;
        message = "Comment fetched successfully!";
      } else {
        error = true;
        message = response['error'] ?? "Failed to fetch comment.";
      }
      return response;
    } catch (e) {
      error = true;
      message = "Error fetching comment: $e";
      return {'status': 'error', 'error': message};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getCommentsByMaterial({
    required String token,
    required String studyMaterialId,
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    comments = [];
    notifyListeners();

    try {
      final response = await commentsApi.getCommentsByMaterial(
        token: token,
        studyMaterialId: studyMaterialId,
      );

      if (response['status'] == 'success') {
        success = true;
        // Ensure each comment has an 'owner_id' for comparison
        comments = (response['comments'] as List).map((comment) {
          // Assuming 'owner_id' is directly available or can be derived
          // from the 'owner' field if it's a user ID, otherwise adjust.
          // For now, we'll assume it's directly provided by the API.
          return comment;
        }).toList();
        owner = response['owner'] ?? '';
        message = "Comments fetched successfully!";
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to fetch comments.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error fetching comments: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getMyComments({
    required String token,
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    comments = [];
    notifyListeners();

    try {
      final response = await commentsApi.getMyComments(
        token: token,
      );

      if (response['status'] == 'success') {
        success = true;
        comments = response['comments'] ?? [];
        message = "My comments fetched successfully!";
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to fetch my comments.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error fetching my comments: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editComment({
    required String token,
    required String commentId,
    required String content,
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await commentsApi.editComment(
        token: token,
        commentId: commentId,
        content: content,
      );

      if (response['status'] == 'success') {
        success = true;
        message = "Comment updated successfully!";
        // Optionally refresh comments for the material if needed
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to update comment.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error updating comment: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteComment({
    required String token,
    required String commentId,
    required String studyMaterialId, // Added to refresh comments after deletion
  }) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await commentsApi.deleteComment(
        token: token,
        commentId: commentId,
      );

      if (response['status'] == 'success') {
        success = true;
        message = "Comment deleted successfully!";
        // Refresh comments for the material after deletion
        await getCommentsByMaterial(token: token, studyMaterialId: studyMaterialId);
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to delete comment.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error deleting comment: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
