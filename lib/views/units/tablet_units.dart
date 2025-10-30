import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/confirm_exit.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/units_widgets/tablet_semester_holder.dart';
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
  @override
  Widget build(BuildContext context) {
    final courses = context.watch<CoursesProvider>().courses;
    final unitsProvider = context.watch<UnitsProvider>();
    final user = context.watch<UserProvider>().user;
    final units = unitsProvider.units;

    final togglesProvider = context.watch<TogglesProvider>();

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmExit(),
        );

        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppUtils.backgroundPanel(context),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppUtils.mainBlue(context),
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              FluentIcons.re_order_24_regular,
              color: AppUtils.mainWhite(context),
            ),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: unitsProvider.isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: LoadingAnimationWidget.newtonCradle(
                    color: AppUtils.mainBlue(context),
                    size: 100,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppUtils.mainBlue(context),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    togglesProvider.searchAction(
                                        searchController.text, units, 'name');
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(12.5),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppUtils.mainWhite(context),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppUtils.mainWhite(context),
                                        width: 2,
                                      ),
                                    ),
                                    filled: false,
                                    prefixIcon: Icon(
                                      FluentIcons.search_24_regular,
                                      color: AppUtils.mainWhite(context)
                                          .withOpacity(0.8),
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.mainWhite(context)
                                            .withOpacity(0.8)),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(
                                        FluentIcons.alert_24_regular,
                                        size: 25,
                                        color: AppUtils.mainWhite(context),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: context
                                                    .watch<DashboardProvider>()
                                                    .isNewActivities
                                                ? AppUtils.mainRed(context)
                                                : AppUtils.mainGrey(context),
                                          ))
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context.go('/settings');
                                      },
                                      icon: Icon(
                                        FluentIcons.settings_24_regular,
                                        size: 25,
                                        color: AppUtils.mainWhite(context),
                                      )),
                                  Gap(10),
                                  SizedBox(
                                    height: 40,
                                    child: VerticalDivider(
                                      color: AppUtils.mainGrey(context),
                                    ),
                                  ),
                                  Gap(10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (context
                                          .watch<UserProvider>()
                                          .isLoading)
                                        SizedBox(
                                          width: 150,
                                          child: LinearProgressIndicator(
                                            minHeight: 1,
                                            color: AppUtils.mainWhite(context),
                                          ),
                                        )
                                      else
                                        Text(
                                            user.isNotEmpty
                                                ? user['username']
                                                : 'Guest',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppUtils.mainWhite(context),
                                                fontWeight: FontWeight.bold)),
                                      if (context
                                          .watch<UserProvider>()
                                          .isLoading)
                                        SizedBox(
                                          width: 50,
                                          child: LinearProgressIndicator(
                                            minHeight: 1,
                                            color: AppUtils.mainWhite(context),
                                          ),
                                        )
                                      else
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                              user.isNotEmpty
                                                  ? user['email']
                                                  : 'guest@email.com',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12,
                                                  color: AppUtils.mainWhite(
                                                      context))),
                                        ),
                                    ],
                                  ),
                                  Gap(10),
                                  CircleAvatar(
                                    child: Icon(FluentIcons.person_24_regular),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (togglesProvider.searchMode)
                      SizedBox(
                        width: double.infinity,
                        child: Text(togglesProvider.searchResults.isEmpty
                            ? "No results found for '${searchController.text}'"
                            : "Search results for '${searchController.text}'"),
                      ),
                    if (user.isNotEmpty && user['role'] == 'admin')
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  const EdgeInsets.all(20)),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppUtils.mainBlue(context)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          onPressed: () {
                            _showDialog(context,
                                courses: courses, token: tokenRef);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Add units",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainWhite(context))),
                              const Gap(5),
                              Icon(FluentIcons.class_24_regular,
                                  size: 16, color: AppUtils.mainWhite(context)),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TabletSemesterHolder(
                                units: togglesProvider.searchResults.isNotEmpty
                                    ? togglesProvider.searchResults
                                    : units),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                      ? MediaQuery.of(context).size.height * 0.65
                      : togglesProvider.showSemesterDropDown
                          ? MediaQuery.of(context).size.height * 0.85
                          : MediaQuery.of(context).size.height * 0.55,
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
                                focusColor: AppUtils.mainBlue(context),
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
                                focusColor: AppUtils.mainBlue(context),
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
                                    focusColor: AppUtils.mainBlue(context),
                                  ),
                                ),
                                if (togglesProvider.showCoursesDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: EdgeInsets.only(top: 5),
                                    width: double.infinity,
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
                                    focusColor: AppUtils.mainBlue(context),
                                  ),
                                ),
                                if (togglesProvider.showSemesterDropDown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: EdgeInsets.only(top: 5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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
                                      alignment: WrapAlignment.spaceEvenly,
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
                                            width: 100,
                                            // padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: selectedSemester ==
                                                        semester
                                                    ? AppUtils.mainBlue(context)
                                                    : AppUtils.mainGrey(
                                                        context),
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
                      Gap(10),
                      Consumer<UnitsProvider>(
                          builder: (context, unitProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: unitProvider.isLoading
                                ? null
                                : () async {
                                    final success = await unitProvider.addUnit(
                                        token,
                                        nameController.text,
                                        'anat.png',
                                        codeController.text,
                                        selectedCourseId,
                                        [],
                                        [],
                                        semesterController.text);
                                    if (success) {
                                      Navigator.of(dialogContext).pop();
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
                                  top: 10, bottom: 10, left: 10, right: 10)),
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
                                : Text('Add Unit',
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
