import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:maktaba/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  String? token;
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';

  final AuthApi authApi = AuthApi();

  AuthProvider() {
    _loadToken();
  }

  // Load token from persistent storage
  Future<void> _loadToken() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('authToken');

      if (token != null && !_isTokenExpired(token!)) {
        isAuthenticated = true;
      } else {
        isAuthenticated = false;
        token = null;
      }
    } catch (e) {
      isAuthenticated = false;
      token = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Save token to persistent storage
  Future<void> _saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', newToken);
  }

  // Get token from Shared Preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Clear token from persistent storage
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  // Check if token is expired
  bool _isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  // Register user and save token
  Future<Map<String, dynamic>> register(String username, String email,
      String password, String phone, String regNo, String image) async {
    isLoading = true;
    success = false;
    error = false;
    notifyListeners();

    try {
      final registerRequest = await authApi.signUp(
        username: username,
        email: email,
        password: password,
        phone: phone,
        regNo: regNo,
        image: image,
      );

      if (registerRequest['status'] == "success") {
        token = registerRequest['token'];
        await _saveToken(token!); // Save token persistently
        isAuthenticated = true;
        message = 'Registration successful';
        success = true;
      } else {
        error = true;
        message = 'Registration failed';
      }
    } catch (e) {
      error = true;
      message = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return {'success': success, 'message': message};
  }

  // Login user and save token
  Future<Map<String, dynamic>> login(String email, String password) async {
    isLoading = true;
    success = false;
    error = false;
    notifyListeners();

    try {
      final loginRequest =
          await authApi.signIN(email: email, password: password);

      if (loginRequest['status'] == "success") {
        isLoading = false;
        token = loginRequest['token'];
        await _saveToken(token!); // Save token persistently
        isAuthenticated = true;
        message = 'Login successful';
        success = true;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = 'Login failed';
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      error = true;
      message = 'Error: $e';
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    } finally {
      isLoading = false;
      Future.delayed(const Duration(seconds: 3), () {
        success = false;
        error = false;
        message = '';
        notifyListeners();
      });
      notifyListeners();
    }
    return {'success': success, 'message': message};
  }

  // update user course
  Future<Map<String, dynamic>> updateCourse(
      String token, String courseId) async {
    isLoading = true;
    success = false;
    error = false;
    notifyListeners();

    try {
      final updateCourseRequest =
          await authApi.updateStudentCourse(token: token, courseId: courseId);

      if (updateCourseRequest['status'] == "success") {
        message = 'Course updated successfully';
        success = true;
        isLoading = false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        error = true;
        message = 'Course update failed';
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
      isLoading = false;
      message = 'Error: $e';
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
  }

  // Check login state
  Future<void> checkLogin() async {
    if (token == null) {
      await _loadToken();
    }
    if (token != null && !_isTokenExpired(token!)) {
      isAuthenticated = true;
    } else {
      isAuthenticated = false;
    }

    notifyListeners();
  }

  // Logout and clear token
  Future<void> logout(BuildContext context) async {
    token = null;
    isAuthenticated = false;
    await _clearToken();

    notifyListeners();

    // Navigate to login screen after logout
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
