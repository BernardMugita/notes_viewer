import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  Map? user;

  bool checkLogin() {
    return isAuthenticated;
  }

  void login(String email, String password) {
    user = {
      'email': email,
      'password': password,
    };

    isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
