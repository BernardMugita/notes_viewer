import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TogglesProvider extends ChangeNotifier {
  TogglesProvider() {
    fetchDismissalStatus();
  }

  List searchResults = [];
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
  bool searchMode = false;
  bool isSearchItemExpanded = false;
  bool isBannerDismissed = false;

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

  void toggleIsSearchItemExpanded() async {
    isSearchItemExpanded = !isSearchItemExpanded;
    notifyListeners();
  }

  void toggleIsUnitExpanded() async {
    isUnitExpanded = !isUnitExpanded;
    notifyListeners();
  }

  void activateSearchMode() async {
    searchMode = true;
    notifyListeners();
  }

  void deActivateSearchMode() async {
    searchMode = false;
    searchResults = [];
    notifyListeners();
  }

  int getWeek(double percent) {
    if (percent <= 25) {
      return 1;
    } else if (percent > 25 && percent <= 50) {
      return 2;
    } else if (percent > 50 && percent <= 75) {
      return 3;
    } else {
      return 4;
    }
  }

  Future<void> fetchDismissalStatus() async {
    isLoading = true;
    notifyListeners();

    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final day = now.day;

    try {
      final prefs = await SharedPreferences.getInstance();
      final prevDismissedDate = prefs.getString('dismissed_date');

      final daysInMonth =
          AppUtils.getMonthsDays(year, month); // get days in month

      final currentPercentage = day / daysInMonth * 100;
      final currentWeek = getWeek(currentPercentage); // get week

      int lastDayDismissed = int.parse(prevDismissedDate!.split('-')[0]);
      final previousPercentage = lastDayDismissed / daysInMonth * 100;
      final previousWeek = getWeek(previousPercentage); // get week

      if (currentWeek > previousWeek) {
        isBannerDismissed = false;
        notifyListeners();

        prefs.setBool('is_dismissed', isBannerDismissed);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> dismissMembershipBanner() async {
    isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;
      final day = now.day;

      String dismissedDate = '$day-$month-$year';
      isBannerDismissed = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('dismissed_date', dismissedDate);
      await prefs.setBool('is_dismissed', isBannerDismissed);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
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

  void searchAction(String query, List originalList, String target) {
    if (query.isEmpty) {
      searchResults = originalList;
      deActivateSearchMode();
    } else {
      activateSearchMode();
      searchResults = originalList
          .where((result) => result[target]
              .toString()
              .toUpperCase()
              .contains(query.toUpperCase()))
          .toList();
    }
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
