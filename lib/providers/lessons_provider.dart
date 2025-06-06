import 'package:flutter/material.dart';
import 'package:maktaba/services/lesson_api.dart';

class LessonsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSortLoading = false;
  bool success = false;
  bool sortSuccess = false;
  bool error = false;
  bool sortError = false;
  String message = '';
  String sortMessage = '';
  bool uploadMode = false;
  List<dynamic> lessons = [];
  Map<String, dynamic> lesson = {};

  LessonApi lessonApi = LessonApi();

  void setUploadMode() {
    uploadMode = true;
    notifyListeners();
  }

  Future<Map<String, dynamic>> createNewLesson(
      String token, String name, String unitId) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final addLessonRequest = await lessonApi.createLesson(
          token: token, name: name, unitId: unitId);

      if (addLessonRequest['status'] == 'success') {
        success = true;
        message = "Lesson added successfully!";
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = "Error adding lesson!";
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      error = true;
      message = "Error adding lesson! $e";
      isLoading = false;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> getLesson(String token, String lessonId) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final getLessonRequest =
          await lessonApi.getLessons(token: token, lessonId: lessonId);

      if (getLessonRequest['status'] == 'success') {
        success = true;
        lesson = getLessonRequest['lesson'];
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = "Error fetching lesson!";
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      error = true;
      message = "Error fetching lesson! $e";
      isLoading = false;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> getAllLesson(String token, String unitId) async {
    isLoading = true;
    lessons = [];
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final getAllLessonsRequest =
          await lessonApi.getAllLessons(token: token, unitId: unitId);

      if (getAllLessonsRequest['status'] == 'success') {
        success = true;
        lessons = getAllLessonsRequest['lessons'];
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = "Error fetching lesson!";
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      error = true;
      message = "Error fetching lesson! $e";
      isLoading = false;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> deleteLesson(
      String token, String lessonId) async {
    isLoading = true;
    error = false;
    success = false;
    notifyListeners();

    try {
      final deleteRequest =
          await lessonApi.deleteLesson(token: token, lessonId: lessonId);

      if (deleteRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        // units = deleteRequest['units'];
        message = "Lesson deleted successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        isLoading = false;
        message = "Failed to delete lesson";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      error = true;
      isLoading = false;
      message = "Failed to delete lesson $e";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> updateLessonSort(
      String token, String lessonId, List sortedMaterial) async {
    isSortLoading = true;
    sortError = false;
    sortMessage = '';
    sortSuccess = false;
    notifyListeners();
    try {
      final updateLessonSortRequest = await lessonApi.addLessonSort(
          token: token, lessonId: lessonId, sortedMaterial: sortedMaterial);
      if (updateLessonSortRequest['status'] == 'success') {
        isSortLoading = false;
        sortSuccess = true;
        sortMessage = "Sort saved successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          sortSuccess = false;
          sortMessage = '';
          notifyListeners();
        });
      } else {
        sortError = true;
        isSortLoading = false;
        sortMessage = "Sort failed to save";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          sortError = false;
          sortMessage = '';
          notifyListeners();
        });
      }
    } catch (e) {
      sortError = true;
      isSortLoading = false;
      sortMessage = "Failed to update lesson sort $e";
      Future.delayed(const Duration(seconds: 3), () {
        sortError = false;
        sortMessage = '';
        notifyListeners();
      });
    }

    return {};
  }
}
