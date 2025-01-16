import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/units_widgets/tablet_semester_holder.dart';
import 'package:provider/provider.dart';

class TabletUnits extends StatefulWidget {
  const TabletUnits({super.key});

  @override
  State<TabletUnits> createState() => _TabletUnitsState();
}

class _TabletUnitsState extends State<TabletUnits> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String tokenRef = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController semesterController = TextEditingController();

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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(FluentIcons.re_order_24_regular),
        ),
      ),
      drawer: const ResponsiveNav(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  FluentIcons.class_24_regular,
                  color: AppUtils.$mainBlue,
                ),
                Text(
                  "Units",
                  style: TextStyle(
                    fontSize: 30,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor:
                          WidgetStatePropertyAll(AppUtils.$mainBlue),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    _showDialog(context, courses: courses, token: tokenRef);
                  },
                  child: Row(
                    children: [
                      Text("Add units",
                          style: TextStyle(
                              fontSize: 16, color: AppUtils.$mainWhite)),
                      Gap(5),
                      Icon(FluentIcons.class_24_regular,
                          size: 16, color: AppUtils.$mainWhite),
                    ],
                  ),
                )
              ],
            ),
            const Gap(10),
            const Divider(
              color: Color(0xFFCECECE),
            ),
            const Gap(20),
            // Make the scrollable content expand dynamically
            Expanded(
              child: SingleChildScrollView(
                // clipBehavior: Clip.none,
                child: Column(
                  children: [
                    TabletSemesterHolder(units: units),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  width: MediaQuery.of(context).size.width,
                  height: togglesProvider.showCoursesDropDown
                      ? MediaQuery.of(context).size.height * 0.55
                      : togglesProvider.showSemesterDropDown
                          ? MediaQuery.of(context).size.height * 0.55
                          : MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: AppUtils.$mainWhite,
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
                              color: AppUtils.$mainBlue,
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
                            width: double.infinity,
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
                                focusColor: AppUtils.$mainBlue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
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
                                focusColor: AppUtils.$mainBlue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
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
                                    focusColor: AppUtils.$mainBlue,
                                  ),
                                ),
                                Gap(10),
                                if (togglesProvider.showCoursesDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppUtils.$mainWhite,
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
                            width: double.infinity,
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
                                    focusColor: AppUtils.$mainBlue,
                                  ),
                                ),
                                Gap(10),
                                if (togglesProvider.showSemesterDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppUtils.$mainWhite,
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
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color:
                                                    selectedSemester == semester
                                                        ? AppUtils.$mainBlue
                                                        : AppUtils.$mainGrey,
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
                          width: double.infinity,
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
                                    : AppUtils.$mainBlue,
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
                                : const Text('Add Unit',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.$mainWhite)),
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
