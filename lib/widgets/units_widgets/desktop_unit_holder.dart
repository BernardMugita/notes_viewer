import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:provider/provider.dart';

class DesktopUnitHolder extends StatefulWidget {
  final Map unit;

  const DesktopUnitHolder({super.key, required this.unit});

  @override
  State<DesktopUnitHolder> createState() => _DesktopUnitHolderState();
}

class _DesktopUnitHolderState extends State<DesktopUnitHolder> {
  bool _isHovered = false;
  Map selectedUnit = {};
  bool isRightClicked = false;

  String tokenRef = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController semesterController = TextEditingController();

  String selectedCourseId = '';
  String selectedSemester = '';

  Future<void> onPointerDown(PointerDownEvent event) async {
    if (event.kind == PointerDeviceKind.mouse &&
        (event.buttons & kSecondaryMouseButton) != 0) {
      setState(() {
        isRightClicked = true;
        selectedUnit = {};
        if (selectedUnit['id'] == widget.unit['id']) {
          selectedUnit = {};
        } else {
          selectedUnit = widget.unit;
        }
      });

      print(selectedUnit);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<CoursesProvider>().fetchCourses(token: token);

        nameController.text = widget.unit['name'];
        codeController.text = widget.unit['code'];
        semesterController.text = widget.unit['semester'];

        selectedCourseId = widget.unit['course_id'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;
    final courses = context.watch<CoursesProvider>().courses;

    final isSelectedUnit = widget.unit['id'] == selectedUnit['id'];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() {
            _isHovered = true;
          }),
          onExit: (_) => setState(() {
            _isHovered = false;
          }),
          child: GestureDetector(
            onTap: () {
              final unitId = unit['id'];
              context.read<UnitsProvider>().setUnitId(unitId);
              context.go('/units/notes');
            },
            child: Listener(
              onPointerDown: onPointerDown,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width / 6,
                decoration: BoxDecoration(
                  color: _isHovered ? AppUtils.$mainBlue : AppUtils.$mainWhite,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      FluentIcons.doctor_24_regular,
                      color:
                          _isHovered ? AppUtils.$mainWhite : AppUtils.$mainBlue,
                      size: 45,
                    ),
                    Text(
                      unit['name'],
                      style: TextStyle(
                        fontSize: 24,
                        color: _isHovered
                            ? AppUtils.$mainWhite
                            : AppUtils.$mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(5),
                    Divider(
                      color: AppUtils.$mainGrey,
                    ),
                    const Gap(5),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.book_24_regular,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue,
                            ),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "Notes",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: context
                                            .watch<TogglesProvider>()
                                            .isHovered
                                        ? AppUtils.$mainWhite
                                        : AppUtils.$mainBlue),
                              ),
                            ),
                            Text(
                              "2",
                              style: TextStyle(
                                color: _isHovered
                                    ? AppUtils.$mainWhite
                                    : AppUtils.$mainBlue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.slide_content_24_regular,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue,
                            ),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "Slides",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: context
                                            .watch<TogglesProvider>()
                                            .isHovered
                                        ? AppUtils.$mainWhite
                                        : AppUtils.$mainBlue),
                              ),
                            ),
                            Text(
                              "4",
                              style: TextStyle(
                                color: _isHovered
                                    ? AppUtils.$mainWhite
                                    : AppUtils.$mainBlue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.video_24_regular,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue,
                            ),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "Recordings",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: context
                                            .watch<TogglesProvider>()
                                            .isHovered
                                        ? AppUtils.$mainWhite
                                        : AppUtils.$mainBlue),
                              ),
                            ),
                            Text(
                              "1",
                              style: TextStyle(
                                color: _isHovered
                                    ? AppUtils.$mainWhite
                                    : AppUtils.$mainBlue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.person_32_regular,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue,
                            ),
                            const Gap(5),
                            Expanded(
                              child: Text(
                                "Student Contributions",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: context
                                            .watch<TogglesProvider>()
                                            .isHovered
                                        ? AppUtils.$mainWhite
                                        : AppUtils.$mainBlue),
                              ),
                            ),
                            Text(
                              "1",
                              style: TextStyle(
                                color: _isHovered
                                    ? AppUtils.$mainWhite
                                    : AppUtils.$mainBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelectedUnit && isRightClicked)
          Positioned(
              right: 0,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 150,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isRightClicked = false;
                                _showDialog(context,
                                    courses: courses, token: tokenRef);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    const Color.fromARGB(121, 70, 131, 0)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Row(
                              children: [
                                Icon(FluentIcons.edit_24_regular,
                                    color: AppUtils.$mainWhite),
                                const Gap(5),
                                Text("Edit",
                                    style:
                                        TextStyle(color: AppUtils.$mainWhite)),
                              ],
                            )),
                        Gap(5),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isRightClicked = false;
                                _showDeleteDialog(context);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(AppUtils.$mainRed),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Row(
                              children: [
                                Icon(FluentIcons.delete_24_regular,
                                    color: AppUtils.$mainWhite),
                                const Gap(5),
                                Text("Delete",
                                    style:
                                        TextStyle(color: AppUtils.$mainWhite)),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      top: -20,
                      right: -20,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              isRightClicked = false;
                              selectedUnit = {};
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(AppUtils.$mainBlack)),
                          icon: Icon(
                            FluentIcons.dismiss_24_regular,
                            color: AppUtils.$mainRed,
                          )))
                ],
              ))
      ],
    );
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
        context: content,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppUtils.$mainWhite,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 300,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.delete_24_regular,
                      color: AppUtils.$mainRed,
                      size: 80,
                    ),
                    Gap(20),
                    Text(
                      "Confirm Delete",
                      style: TextStyle(fontSize: 18, color: AppUtils.$mainRed),
                    ),
                    Text(
                      "Are you sure you want to delete this unit? Note that this action is irreversible.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    context.pop();
                                  });
                                },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.$mainBlueAccent),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.dismiss_24_filled,
                                        color: AppUtils.$mainRed),
                                    const Gap(5),
                                    Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.$mainRed)),
                                  ],
                                ))),
                        Gap(10),
                        Expanded(
                          child: Consumer<UnitsProvider>(
                              builder: (context, unitsProvider, _) {
                            return ElevatedButton(
                                onPressed: unitsProvider.isLoading
                                    ? null
                                    : () {
                                        unitsProvider.deleteUnit(
                                            tokenRef, widget.unit['id']);
                                      },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.$mainRed),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: unitsProvider.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FluentIcons.delete_24_regular,
                                              color: AppUtils.$mainWhite),
                                          const Gap(5),
                                          Text("Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppUtils.$mainWhite)),
                                        ],
                                      ));
                          }),
                        )
                      ],
                    ))
                  ],
                )),
          );
        });
  }

  void _showDialog(BuildContext context,
      {required List<Map<String, dynamic>> courses, required String token}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final semesters = context.read<UnitsProvider>().semesters;

        final Map newUnit = {
          'name': nameController.text,
          'img': 'anat.png',
          'code': codeController.text,
          'course_id': selectedCourseId,
          'students': [],
          'assignments': [],
          'semester': semesterController.text,
          'unit_id': widget.unit['id']
        };

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
                      ? MediaQuery.of(context).size.height * 0.6
                      : togglesProvider.showSemesterDropDown
                          ? MediaQuery.of(context).size.height * 0.7
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
                            "Edit Unit",
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
                                focusColor: AppUtils.$mainBlue,
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
                                focusColor: AppUtils.$mainBlue,
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
                                    focusColor: AppUtils.$mainBlue,
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
                                    focusColor: AppUtils.$mainBlue,
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
                                            padding: const EdgeInsets.all(10),
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
                      Spacer(),
                      Consumer<UnitsProvider>(
                          builder: (context, unitProvider, child) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                            onPressed: unitProvider.isLoading
                                ? null
                                : () {
                                    unitProvider.editUserUnit(token, newUnit);
                                    if (unitProvider.success) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        context.pop();
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
                                : const Text('Save changes',
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
