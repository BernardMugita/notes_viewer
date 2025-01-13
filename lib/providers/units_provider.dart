import 'package:flutter/material.dart';
import 'package:note_viewer/services/units_api.dart';

class UnitsProvider extends ChangeNotifier {
  bool success = false;
  bool isLoading = false;
  bool error = false;
  String message = '';
  List units = [];

  UnitsApi unitsApi = UnitsApi();

  List<String> semesters = [
    '1.1',
    '1.2',
    '2.1',
    '2.2',
    '3.1',
    '3.2',
    '4.1',
    '4.2'
  ];

  Future<Map<String, dynamic>> addUnit(
    String token,
    String name,
    String img,
    String code,
    String courseId,
    List students,
    List assignments,
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

      print(addRequest);

      if (addRequest['status'] == 'success') {
        success = true;
        isLoading = false;
        message = "Unit added successfully";
        notifyListeners();
      } else {
        error = true;
        isLoading = false;
        message = "Failed to add unit";
        notifyListeners();
      }
    } catch (e) {
      error = true;
      isLoading = false;
      message = "Failed to add unit $e";
      notifyListeners();
      return {'status': 'error', 'message': e.toString()};
    }

    return {};
  }

  Future<Map<String, dynamic>> fetchUserUnits(String token) async {
    isLoading = true;
    error = false;
    success = false;
    notifyListeners();

    try {
      final fetchRequest = await unitsApi.getUserUnits(token: token);

      if (fetchRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        units = fetchRequest['units'];
        notifyListeners();
      } else {
        error = true;
        isLoading = false;
        message = "Failed to fetch units";
        notifyListeners();
      }
    } catch (e) {
      error = true;
      isLoading = false;
      message = "Failed to fetch units $e";
      notifyListeners();
    }

    return {};
  }
}