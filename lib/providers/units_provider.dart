import 'package:flutter/material.dart';
import 'package:maktaba/services/units_api.dart';

class UnitsProvider extends ChangeNotifier {
  bool success = false;
  bool isLoading = false;
  bool error = false;
  String message = '';
  List units = [];

  String unitId = '';

  // String get unitId => _unitId;

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

  void setUnitId(String id) {
    unitId = id;
    notifyListeners();
  }

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

      if (addRequest['status'] == 'success') {
        success = true;
        isLoading = false;
        message = "Unit added successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        isLoading = false;
        message = "Failed to add unit";
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
      message = "Failed to add unit $e";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });

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
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        isLoading = false;
        message = "Failed to fetch units";
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
      message = "Failed to fetch units $e";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> editUserUnit(String token, Map newUnit) async {
    isLoading = true;
    error = false;
    success = false;
    notifyListeners();

    try {
      final editUnitRequest =
          await unitsApi.editUserUnits(token: token, newUnit: newUnit);

      if (editUnitRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        units = editUnitRequest['units'];
        message = "Unit edited successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        isLoading = false;
        message = "Failed to edit unit";
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
      message = "Failed to edit unit $e";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  Future<Map<String, dynamic>> deleteUnit(String token, String unitId) async {
    isLoading = true;
    error = false;
    success = false;
    notifyListeners();

    try {
      final deleteRequest =
          await unitsApi.deleteUnit(token: token, unitId: unitId);

      if (deleteRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        units = deleteRequest['units'];
        message = "Unit deleted successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        isLoading = false;
        message = "Failed to delete unit";
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
      message = "Failed to delete unit $e";
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
