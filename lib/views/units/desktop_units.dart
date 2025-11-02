import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
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
        context.read<CoursesProvider>().getAllCourses(token: token);
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

    return context.watch<UnitsProvider>().isLoading
        ? Center(
            child: Lottie.asset("assets/animations/maktaba_loader.json"),
          )
        : Scaffold(
            backgroundColor: AppUtils.backgroundPanel(context),
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
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                        top: 20,
                        bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        _buildTopBar(context, toggleProvider, user,
                            context.watch<DashboardProvider>().isNewActivities),
                        // Page Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (toggleProvider.searchMode)
                                  Text(
                                    toggleProvider.searchResults.isEmpty
                                        ? "No results found"
                                        : "Search results for '${searchController.text}'",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainGrey(context),
                                    ),
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Units',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppUtils.mainBlack(context),
                                        ),
                                      ),
                                      Gap(4),
                                      Text(
                                        'Manage your course units',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppUtils.mainGrey(context),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            if (user.isNotEmpty &&
                                user['role'] == 'admin' &&
                                !toggleProvider.searchMode)
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppUtils.mainBlue(context)),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  elevation: WidgetStatePropertyAll(0),
                                ),
                                onPressed: () => _showDialog(context,
                                    courses: courses, token: tokenRef),
                                icon: Icon(
                                  FluentIcons.add_24_regular,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Add Unit",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Units Content
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

  Widget _buildTopBar(BuildContext context, TogglesProvider togglesProvider,
      Map<dynamic, dynamic> user, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
              onChanged: (value) {
                togglesProvider.searchAction(
                  searchController.text,
                  context.read<UnitsProvider>().units,
                  'name',
                );
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppUtils.mainWhite(context).withOpacity(0.1),
                prefixIcon: Icon(
                  FluentIcons.search_24_regular,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search units...",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.alert_24_regular,
                      size: 24,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                  if (isNewActivities)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppUtils.mainRed(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(8),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  user.isNotEmpty ? user['username'][0].toUpperCase() : 'G',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context,
      {required List<Map<String, dynamic>> courses, required String token}) {
    final _formKey = GlobalKey<FormState>();

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
                  padding: const EdgeInsets.all(28),
                  width: MediaQuery.of(context).size.width * 0.35,
                  constraints: BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Unit",
                              style: TextStyle(
                                fontSize: 22,
                                color: AppUtils.mainBlue(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: const Icon(FluentIcons.dismiss_24_regular),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // Unit Name
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(FluentIcons.class_24_regular),
                            labelText: 'Unit Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppUtils.mainBlue(context),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a unit name'
                              : null,
                        ),
                        const Gap(16),

                        // Unit Code
                        TextFormField(
                          controller: codeController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                                FluentIcons.number_circle_0_24_regular),
                            labelText: 'Unit Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppUtils.mainBlue(context),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a unit code'
                              : null,
                        ),
                        const Gap(16),

                        // Course Dropdown
                        Column(
                          children: [
                            TextFormField(
                              controller: courseIdController,
                              readOnly: true,
                              onTap: () {
                                togglesProvider.toggleCoursesDropDown();
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(FluentIcons.book_24_regular),
                                labelText: 'Course',
                                suffixIcon: Icon(
                                  togglesProvider.showCoursesDropDown
                                      ? FluentIcons.chevron_up_24_regular
                                      : FluentIcons.chevron_down_24_regular,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppUtils.mainBlue(context),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please select a course'
                                  : null,
                            ),
                            if (togglesProvider.showCoursesDropDown)
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                constraints: BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppUtils.mainWhite(context),
                                  border: Border.all(
                                    color: AppUtils.mainGrey(context)
                                        .withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: courses.map<Widget>((course) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCourseId = course['id'];
                                          courseIdController.text =
                                              course['name'];
                                        });
                                        togglesProvider.toggleCoursesDropDown();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color:
                                              selectedCourseId == course['id']
                                                  ? AppUtils.mainBlue(context)
                                                      .withOpacity(0.1)
                                                  : Colors.transparent,
                                        ),
                                        child: Text(
                                          course['name'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: selectedCourseId ==
                                                    course['id']
                                                ? AppUtils.mainBlue(context)
                                                : AppUtils.mainBlack(context),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                        const Gap(16),

                        // Semester Dropdown
                        Column(
                          children: [
                            TextFormField(
                              controller: semesterController,
                              readOnly: true,
                              onTap: () {
                                togglesProvider.toggleSemesterDropDown();
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(FluentIcons.calendar_24_regular),
                                labelText: 'Semester',
                                suffixIcon: Icon(
                                  togglesProvider.showSemesterDropDown
                                      ? FluentIcons.chevron_up_24_regular
                                      : FluentIcons.chevron_down_24_regular,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppUtils.mainBlue(context),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please select a semester'
                                  : null,
                            ),
                            if (togglesProvider.showSemesterDropDown)
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppUtils.mainWhite(context),
                                  border: Border.all(
                                    color: AppUtils.mainGrey(context)
                                        .withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: semesters.map<Widget>((semester) {
                                    final isSelected =
                                        selectedSemester == semester;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedSemester = semester;
                                          semesterController.text = semester;
                                        });
                                        togglesProvider
                                            .toggleSemesterDropDown();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: isSelected
                                              ? AppUtils.mainBlue(context)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppUtils.mainBlue(context)
                                                : AppUtils.mainGrey(context)
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          semester,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected
                                                ? Colors.white
                                                : AppUtils.mainBlack(context),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                        const Gap(24),

                        // Submit Button
                        Consumer<UnitsProvider>(
                            builder: (context, unitProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: unitProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success =
                                            await unitProvider.addUnit(
                                          token,
                                          nameController.text,
                                          'anat.png',
                                          codeController.text,
                                          selectedCourseId,
                                          [],
                                          [],
                                          semesterController.text,
                                        );
                                        if (success) {
                                          Navigator.of(dialogContext).pop();
                                        }
                                      }
                                    },
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  unitProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                ),
                              ),
                              child: unitProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Add Unit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              if (context.watch<UnitsProvider>().success)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SuccessWidget(
                      message: context.watch<UnitsProvider>().message),
                )
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
