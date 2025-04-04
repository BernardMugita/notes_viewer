import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:maktaba/widgets/app_widgets/navigation/top_navigation.dart';
import 'package:maktaba/widgets/units_widgets/desktop_semester_holder.dart';
import 'package:provider/provider.dart';

class DesktopUnits extends StatefulWidget {
  const DesktopUnits({super.key});

  @override
  State<DesktopUnits> createState() => _DesktopUnitsState();
}

class _DesktopUnitsState extends State<DesktopUnits> {
  String tokenRef = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String selectedCourseId = '';
  String selectedSemester = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<CoursesProvider>().fetchCourses(token: token);
        context.read<UnitsProvider>().fetchUserUnits(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<CoursesProvider>().courses;
    final unitsProvider = context.watch<UnitsProvider>();
    final units = unitsProvider.units;

    final user = context.watch<UserProvider>().user;

    final toggleProvider = context.watch<TogglesProvider>();

    bool isMinimized = toggleProvider.isSideNavMinimized;

    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          isMinimized
              ? Expanded(
                  flex: 1,
                  child: SideNavigation(),
                )
              : SizedBox(
                  width: 80,
                  child: SideNavigation(),
                ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: 20,
                  bottom: 20),
              child: context.watch<UnitsProvider>().isLoading
                  ? Center(
                      child: LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.mainBlue(context),
                        size: 100,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        // if (!context
                    //           .watch<TogglesProvider>()
                    //           .isBannerDismissed)
                    //         Consumer<TogglesProvider>(
                    //         builder: (context, toggleProvider, _) {
                    //       return toggleProvider.isBannerDismissed
                    //           ? SizedBox()
                    //           : MembershipBanner();
                    //     }),
                        Row(
                          children: [
                            Text(
                              "Units",
                              style: TextStyle(
                                fontSize: 24,
                                color: AppUtils.mainBlue(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            TopNavigation(
                                isRecentActivities: context
                                    .watch<DashboardProvider>()
                                    .isNewActivities)
                          ],
                        ),
                        const Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  toggleProvider.searchAction(
                                      searchController.text, units, 'name');

                                  print(toggleProvider.searchResults);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.5),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppUtils.mainBlueAccent(context))),
                                  filled: true,
                                  fillColor: AppUtils.mainWhite(context),
                                  prefixIcon:
                                      Icon(FluentIcons.search_24_regular),
                                  hintText: "Search",
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Gap(10),
                            if (toggleProvider.searchMode)
                              SizedBox(
                                width: double.infinity,
                                child: Text(toggleProvider.searchResults.isEmpty
                                    ? "No results found for '${searchController.text}'"
                                    : "Search results for '${searchController.text}'"),
                              ),
                            Gap(10),
                            if (user.isNotEmpty && user['role'] == 'admin')
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(20)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainBlue(context)),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => _showDialog(context,
                                      courses: courses, token: tokenRef),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Add units",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Gap(5),
                                      Icon(
                                        FluentIcons.class_24_regular,
                                        size: 16,
                                        color: AppUtils.mainWhite(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Gap(20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DesktopSemesterHolder(
                                    units:
                                        toggleProvider.searchResults.isNotEmpty
                                            ? toggleProvider.searchResults
                                            : units),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context,
      {required List<Map<String, dynamic>> courses, required String token}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final semesters = context.read<UnitsProvider>().semesters;

        return Consumer<TogglesProvider>(
            builder: (context, togglesProvider, _) {
          return Stack(
            children: [
              AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: togglesProvider.showCoursesDropDown
                      ? MediaQuery.of(context).size.height * 0.65
                      : togglesProvider.showSemesterDropDown
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Unit",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppUtils.mainBlue(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            icon: const Icon(FluentIcons.dismiss_24_regular),
                          ),
                        ],
                      ),
                      Gap(20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(FluentIcons.class_24_regular),
                                labelText: 'Unit name',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                focusColor: AppUtils.mainBlue(context),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              controller: codeController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                    FluentIcons.number_circle_0_24_regular),
                                labelText: 'Unit code',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                focusColor: AppUtils.mainBlue(context),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Column(
                              children: [
                                TextField(
                                  controller: courseIdController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(right: 10),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        togglesProvider.toggleCoursesDropDown();
                                      },
                                      icon: togglesProvider.showCoursesDropDown
                                          ? const Icon(
                                              FluentIcons.chevron_up_24_regular)
                                          : const Icon(FluentIcons
                                              .chevron_down_24_regular),
                                    ),
                                    prefixIcon:
                                        const Icon(FluentIcons.book_24_regular),
                                    labelText: 'Course',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 212, 212, 212),
                                      ),
                                    ),
                                    focusColor: AppUtils.mainBlue(context),
                                  ),
                                ),
                                Gap(10),
                                if (togglesProvider.showCoursesDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppUtils.mainWhite(context),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                              255, 229, 229, 229),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: courses.map<Widget>((course) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCourseId = course[
                                                  'id']; // Set the course ID
                                              courseIdController.text = course[
                                                  'name']; // Update the course name in the text field
                                            });
                                            togglesProvider
                                                .toggleCoursesDropDown();
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course['name'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              const Divider(
                                                color: Color.fromARGB(
                                                    255, 209, 209, 209),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Column(
                              children: [
                                TextField(
                                  controller: semesterController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        togglesProvider
                                            .toggleSemesterDropDown();
                                      },
                                      icon: togglesProvider.showSemesterDropDown
                                          ? const Icon(
                                              FluentIcons.chevron_up_24_regular)
                                          : const Icon(FluentIcons
                                              .chevron_down_24_regular),
                                    ),
                                    prefixIcon: const Icon(
                                        FluentIcons.calendar_24_regular),
                                    labelText: 'Semester',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 212, 212, 212),
                                      ),
                                    ),
                                    focusColor: AppUtils.mainBlue(context),
                                  ),
                                ),
                                Gap(10),
                                if (togglesProvider.showSemesterDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppUtils.mainWhite(context),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                              255, 229, 229, 229),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children:
                                          semesters.map<Widget>((semester) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedSemester =
                                                  semester; // Update selected semester
                                              semesterController.text =
                                                  semester;
                                              togglesProvider
                                                  .toggleSemesterDropDown(); // Close the dropdown
                                            });
                                          },
                                          child: Container(
                                            width: 120,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color:
                                                    selectedSemester == semester
                                                        ? AppUtils.mainBlue(context)
                                                        : AppUtils.mainGrey(context),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: selectedSemester ==
                                                      semester,
                                                  onChanged: (selected) {
                                                    setState(() {
                                                      selectedSemester =
                                                          semester; // Update the selected semester
                                                    });
                                                  },
                                                ),
                                                const Gap(5),
                                                Text(
                                                  semester,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(20),
                      Consumer<UnitsProvider>(
                          builder: (context, unitProvider, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                            onPressed: unitProvider.isLoading
                                ? null
                                : () {
                                    unitProvider.addUnit(
                                        token,
                                        nameController.text,
                                        'anat.png',
                                        codeController.text,
                                        selectedCourseId,
                                        [],
                                        [],
                                        semesterController.text);
                                    if (unitProvider.success) {
                                      unitProvider.fetchUserUnits(token);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.of(dialogContext).pop();
                                      });
                                    }
                                  },
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor: WidgetStatePropertyAll(
                                unitProvider.isLoading
                                    ? Colors.grey
                                    : AppUtils.mainBlue(context),
                              ),
                              padding: WidgetStatePropertyAll(EdgeInsets.only(
                                  top: 20, bottom: 20, left: 10, right: 10)),
                            ),
                            child: unitProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                :  Text('Add Unit',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.mainWhite(context))),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
              if (context.watch<UnitsProvider>().success)
                Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<UnitsProvider>().message))
              else if (context.watch<UnitsProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<UnitsProvider>().message),
                )
            ],
          );
        });
      },
    );
  }
}
