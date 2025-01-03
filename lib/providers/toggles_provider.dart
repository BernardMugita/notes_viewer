import 'package:flutter/material.dart';

class TogglesProvider extends ChangeNotifier {
  bool showPassword = false;
  bool showCoursesDropDown = false;
  bool rememberSelection = false;
  bool showSearchBar = false;

  void togglePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleCoursesDropDown() {
    showCoursesDropDown = !showCoursesDropDown;
    notifyListeners();
  }

  void toggleRememberSelection() {
    rememberSelection = !rememberSelection;
    notifyListeners();
  }

  void toggleSearchBar() {
    showSearchBar = !showSearchBar;
    notifyListeners();
  }
}
