import 'package:flutter/material.dart';
import 'package:maktaba/services/courses_api.dart';

class CoursesProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';
  List<Map<String, dynamic>> courses = [];
  Map<String, dynamic> course = {};

  CoursesApi coursesApi = CoursesApi();

  Future<bool> getCourse({required String token, required String id}) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    course = {};
    notifyListeners();

    try {
      final response = await coursesApi.getCourse(token: token, id: id);

      if (response['status'] == 'success') {
        success = true;
        course = response['course'] ?? {};
        message = "Course fetched successfully!";
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to fetch course.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error fetching course: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getAllCourses({required String token}) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    courses = [];
    notifyListeners();

    try {
      final response = await coursesApi.getAllCourses(token: token);

      if (response['status'] == 'success') {
        success = true;
        final List<dynamic> coursesData = response['courses'] ?? [];
        courses = coursesData
            .map((course) => course as Map<String, dynamic>)
            .toList();
        message = "Courses fetched successfully!";
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to fetch courses.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error fetching courses: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCourse(
      {required String token, required Map<String, String> body}) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await coursesApi.addCourse(token: token, body: body);

      if (response['status'] == 'success') {
        success = true;
        message = "Course added successfully!";
        await getAllCourses(token: token);
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to add course.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error adding course: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCourse(
      {required String token, required Map<String, String> body}) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await coursesApi.updateCourse(token: token, body: body);

      if (response['status'] == 'success') {
        success = true;
        message = "Course updated successfully!";
        await getAllCourses(token: token);
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to update course.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error updating course: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCourse(
      {required String token, required String id}) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final response = await coursesApi.deleteCourse(token: token, id: id);

      if (response['status'] == 'success') {
        success = true;
        message = "Course deleted successfully!";
        await getAllCourses(token: token);
        return true;
      } else {
        error = true;
        message = response['error'] ?? "Failed to delete course.";
        return false;
      }
    } catch (e) {
      error = true;
      message = "Error deleting course: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
