import 'package:flutter/material.dart';
import 'package:note_viewer/services/courses_api.dart';

class CoursesProvider extends ChangeNotifier {
  bool isFetchingCourses = false;
  bool success = false;
  bool error = false;

  List<Map<String, dynamic>> courses = [];
  CoursesApi coursesApi = CoursesApi();

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
}
