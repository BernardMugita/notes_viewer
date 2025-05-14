import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maktaba/services/dash_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  bool error = false;
  bool success = false;
  String message = '';
  Map dashData = {};
  Map currentlyViewing = {};
  DashApi dashApi = DashApi();

  bool isNewActivities = false;

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
        isNewActivities = dashData['notifications']['unread'].isNotEmpty;
        fetchUsersRecentlyViewedMaterial(dashData['user']['id']);
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = "Failed to fetch data";
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
      message = "Failed to fetch data $e";
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

  void saveUsersRecentlyViewedMaterial(Map viewingMetaData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString(viewingMetaData['user_id'], jsonEncode(viewingMetaData));
    } catch (e) {
      print(e);
    }
  }

  void fetchUsersRecentlyViewedMaterial(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(userId)) {
        currentlyViewing = jsonDecode(prefs.getString(userId)!);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
