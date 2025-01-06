import 'package:flutter/material.dart';

class TogglesProvider extends ChangeNotifier {
  bool showPassword = false;
  bool showCoursesDropDown = false;
  bool rememberSelection = false;
  bool showSearchBar = false;
  bool showGroupDropDown = false;
  bool showFilterDropDown = false;
  bool showSortDropDown = false;
  bool selectGroup = false;

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

  void toggleGroupDropDown() {
    showGroupDropDown = !showGroupDropDown;
    showFilterDropDown = false;
    showSortDropDown = false;
    notifyListeners();
  }

  void toggleFilterDropDown() {
    showFilterDropDown = !showFilterDropDown;
    showGroupDropDown = false;
    showSortDropDown = false;
    notifyListeners();
  }

  void toggleSortDropDown() {
    showSortDropDown = !showSortDropDown;
    showGroupDropDown = false;
    showFilterDropDown = false;
    notifyListeners();
  }

  void toggleSelectGroup() {
    selectGroup = !selectGroup;
    notifyListeners();
  }
}
