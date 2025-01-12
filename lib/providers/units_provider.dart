import 'package:flutter/material.dart';
import 'package:note_viewer/services/units_api.dart';

class UnitsProvider extends ChangeNotifier {
  bool success = false;
  bool isLoading = false;
  bool error = false;

  UnitsApi unitsApi = UnitsApi();

  Future<Map<String, dynamic>> addUnit(
    String token,
    String name,
    String img,
    String code,
    String courseId,
    String students,
    String assignments,
    String semester,
  ) async {
    isLoading = true;
    error = false;
    success = false;
    notifyListeners();

    try {
      final addRequest = await unitsApi.addNewUnit(
          token: token,
          name: name,
          img: img,
          code: code,
          courseId: courseId,
          students: students,
          assignments: assignments,
          semester: semester);

      if (addRequest['status'] == 'success') {
        success = true;
        isLoading = false;
        notifyListeners();
      } else {
        error = true;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = true;
      isLoading = false;
      notifyListeners();
      return {'status': 'error', 'message': e.toString()};
    }

    return {};
  }
}
