import 'package:flutter/material.dart';
import 'package:note_viewer/services/courses_api.dart';

class CoursesProvider extends ChangeNotifier {
  bool isFetchingCourses = false;
  bool success = false;
  bool error = false;

  List<Map<String, dynamic>> courses = [];
  CoursesApi coursesApi = CoursesApi();
  Map<String, dynamic> course = {};

  Future<Map<String, dynamic>> fetchCourses({required String? token}) async {
    isFetchingCourses = true;
    notifyListeners();

    try {
      final fetchCoursesRequest = await coursesApi.getAllCourses(token: token);
      isFetchingCourses = false;
      success = true;

      if (fetchCoursesRequest['status'] == 'success') {
        courses =
            List<Map<String, dynamic>>.from(fetchCoursesRequest['courses']);

        notifyListeners();
        return {'status': 'success'};
      } else {
        error = true;
        return {'status': 'error', 'message': fetchCoursesRequest['message']};
      }
    } catch (e) {
      isFetchingCourses = false;
      error = true;
      notifyListeners();
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchCourse(
      {required String? token, required String id}) async {
    isFetchingCourses = true;
    notifyListeners();

    try {
      final fetchCourseRequest =
          await coursesApi.getCourse(token: token, id: id);
      isFetchingCourses = false;
      success = true;

      if (fetchCourseRequest['status'] == 'success') {
        course = Map<String, dynamic>.from(fetchCourseRequest['course']);

        notifyListeners();
        return {'status': 'success'};
      } else {
        error = true;
        return {'status': 'error', 'message': fetchCourseRequest['message']};
      }
    } catch (e) {
      isFetchingCourses = false;
      error = true;
      notifyListeners();
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
