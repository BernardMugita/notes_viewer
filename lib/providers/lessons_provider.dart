import 'package:flutter/material.dart';
import 'package:note_viewer/services/lesson_api.dart';

class LessonsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';
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
}
