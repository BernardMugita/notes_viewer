import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TogglesProvider extends ChangeNotifier {
  bool showPassword = false;
  bool showCoursesDropDown = false;
  bool rememberSelection = false;
  bool showSearchBar = false;
  bool showGroupDropDown = false;
  bool showFilterDropDown = false;
  bool showSortDropDown = false;
  bool selectGroup = false;
  bool showSemesterDropDown = false;
  bool isLoading = false;
  bool accountView = true;
  bool membershipView = false;
  bool isHovered = false;
  bool isRightClicked = false;
  bool isLessonSelected = false;
  bool showUploadTypeDropdown = false;
  bool showDocumentMeta = false;
  bool isSideNavMinimized = false;
  bool isActivityExpanded = false;
  bool isUnitExpanded = false;

  void togglePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleCoursesDropDown() {
    showSemesterDropDown = false;

    showCoursesDropDown = !showCoursesDropDown;
    notifyListeners();
  }

  void toggleSelectLesson() {
    isLessonSelected = true;
    notifyListeners();
  }

  void toggleSemesterDropDown() {
    showCoursesDropDown = false;

    showSemesterDropDown = !showSemesterDropDown;
    notifyListeners();
  }

  void toggleRememberSelection() async {
    rememberSelection = !rememberSelection;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_selection', rememberSelection);
    notifyListeners();
  }

  void toggleUploadTypeDropDown() async {
    showUploadTypeDropdown = !showUploadTypeDropdown;
    notifyListeners();
  }

  void toggleDocumentMeta() async {
    showDocumentMeta = !showDocumentMeta;
    notifyListeners();
  }

  void toggleSideNavMinimized() async {
    isSideNavMinimized = !isSideNavMinimized;
    notifyListeners();
  }

  void toggleIsActivityExpanded() async {
    isActivityExpanded = !isActivityExpanded;
    notifyListeners();
  }

  void toggleIsUnitExpanded() async {
    isUnitExpanded = !isUnitExpanded;
  }

  Future<void> loadRememberSelection() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      rememberSelection = prefs.getBool('remember_selection') ?? false;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future toggleIsHovered() async {
    isHovered = !isHovered;
    notifyListeners();
  }

  Future<void> toggleIsRightClicked() async {
    isRightClicked = !isRightClicked;
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

  void toggleMembershipView() {
    membershipView = true;
    accountView = false;
    notifyListeners();
  }

  void toggleAccountView() {
    accountView = true;
    membershipView = false;
    notifyListeners();
  }
}
