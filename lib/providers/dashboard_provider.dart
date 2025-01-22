import 'package:flutter/material.dart';
import 'package:note_viewer/services/dash_api.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  bool error = false;
  bool success = false;
  String message = '';
  Map dashData = {};

  DashApi dashApi = DashApi();

  Future<Map<String, dynamic>> fetchDashData(String token) async {
    isLoading = true;
    error = false;
    success = false;
    message = '';
    notifyListeners();

    try {
      final dashDataRequest = await dashApi.getDashData(token: token);

      if (dashDataRequest['status'] == "success") {
        success = true;
        message = "Data fetched successfully";
        dashData = dashDataRequest['data'];
        isLoading = false;
        notifyListeners();
      } else {
        error = true;
        message = "Failed to fetch data";
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = true;
      message = "Failed to fetch data $e";
      isLoading = false;
      notifyListeners();
    }

    return {};
  }
}
