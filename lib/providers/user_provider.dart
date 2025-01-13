import 'package:flutter/material.dart';
import 'package:note_viewer/services/user_api.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';
  Map<String, dynamic> user = {};

  UserApi userApi = UserApi();

  Future<Map<String, dynamic>> fetchUserDetails(String token) async {
    isLoading = true;
    success = false;
    error = false;
    notifyListeners();

    try {
      final fetchRequest = await userApi.getUser(token: token);

      if (fetchRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        user = fetchRequest['user'];
        notifyListeners();
      } else {
        error = true;
        isLoading = false;
        message = "Failed to fetch user details";
        notifyListeners();
      }
    } catch (e) {
      error = true;
      isLoading = false;
      message = "Failed to fetch user details $e";
      notifyListeners();
    }

    return {};
  }

  Future<Map<String, dynamic>> editUserDetails(String token, String email,
      String username, String phone, String image) async {
    isLoading = true;
    success = false;
    error = false;
    notifyListeners();

    try {
      final editAccountRequest = await userApi.editUser(
          token: token,
          username: username,
          email: email,
          image: image,
          phone: phone);

      if (editAccountRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        user = editAccountRequest['user'];
        notifyListeners();
      } else {
        error = true;
        isLoading = false;
        message = "Failed to edit user details";
        notifyListeners();
      }
    } catch (e) {
      error = true;
      isLoading = false;
      message = "Failed to edit user details $e";
      notifyListeners();
    }

    return {};
  }
}
