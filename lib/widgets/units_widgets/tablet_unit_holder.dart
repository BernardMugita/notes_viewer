import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:provider/provider.dart';

class TabletUnitHolder extends StatefulWidget {
  final Map unit;

  const TabletUnitHolder({super.key, required this.unit});

  @override
  State<TabletUnitHolder> createState() => _TabletUnitHolderState();
}

class _TabletUnitHolderState extends State<TabletUnitHolder> {
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
        isRightClicked = !isRightClicked;
        selectedUnit = {};
        if (selectedUnit['id'] == widget.unit['id']) {
          selectedUnit = {};
        } else {
          selectedUnit = widget.unit;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<CoursesProvider>().getAllCourses(token: token);

        nameController.text = widget.unit['name'];
        codeController.text = widget.unit['code'];
        semesterController.text = widget.unit['semester'];

        selectedCourseId = widget.unit['course_id'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final unit = widget.unit;
    final courses = context.watch<CoursesProvider>().courses;
    final isSelectedUnit = widget.unit['id'] == selectedUnit['id'];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              final unitId = unit['id'];
              context.read<UnitsProvider>().setUnitId(unitId);
              context.go('/units/notes');
              context.read<TogglesProvider>().deActivateSearchMode();
            },
            child: Listener(
              onPointerDown: onPointerDown,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppUtils.mainBlue(context)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isHovered
                        ? AppUtils.mainBlue(context)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Unit Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isHovered
                                ? Colors.white.withOpacity(0.2)
                                : AppUtils.mainBlue(context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            FluentIcons.book_24_filled,
                            size: 20,
                            color: _isHovered
                                ? Colors.white
                                : AppUtils.mainBlue(context),
                          ),
                        ),
                        const Gap(12),

                        // Unit Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isHovered
                                          ? Colors.white.withOpacity(0.2)
                                          : AppUtils.mainBlue(context)
                                              .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      unit['code'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _isHovered
                                            ? Colors.white
                                            : AppUtils.mainBlue(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(6),
                              Text(
                                unit['name'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _isHovered
                                      ? Colors.white
                                      : AppUtils.mainBlack(context),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Actions
                        Consumer<TogglesProvider>(
                          builder: (context, toggleProvider, _) {
                            return Row(
                              children: [
                                if (user.isNotEmpty && user['role'] == 'admin')
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _isHovered
                                          ? Colors.white.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: PopupMenuButton<String>(
                                      icon: Icon(
                                        FluentIcons.more_vertical_24_regular,
                                        color: _isHovered
                                            ? Colors.white
                                            : AppUtils.mainGrey(context),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _showDialog(context,
                                              courses: courses,
                                              token: tokenRef);
                                        } else if (value == 'delete') {
                                          _showDeleteDialog(context);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(FluentIcons.edit_24_regular,
                                                  size: 18,
                                                  color: AppUtils.mainBlue(
                                                      context)),
                                              const Gap(12),
                                              const Text('Edit Unit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                  FluentIcons.delete_24_regular,
                                                  size: 18,
                                                  color: AppUtils.mainRed(
                                                      context)),
                                              const Gap(12),
                                              const Text('Delete Unit'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Gap(8),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedUnit = {};
                                      if (selectedUnit['id'] ==
                                              widget.unit['id'] ||
                                          toggleProvider.isUnitExpanded) {
                                        selectedUnit = {};
                                      } else {
                                        selectedUnit = widget.unit;
                                      }
                                    });
                                    toggleProvider.toggleIsUnitExpanded();
                                  },
                                  icon: Icon(
                                    isSelectedUnit &&
                                            toggleProvider.isUnitExpanded
                                        ? FluentIcons.chevron_up_24_regular
                                        : FluentIcons.chevron_down_24_regular,
                                    color: _isHovered
                                        ? Colors.white
                                        : AppUtils.mainGrey(context),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),

                    // Expanded Details
                    if (isSelectedUnit &&
                        context.watch<TogglesProvider>().isUnitExpanded)
                      Column(
                        children: [
                          const Gap(16),
                          Divider(
                            color: _isHovered
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.shade300,
                            height: 1,
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailChip(
                                  context,
                                  FluentIcons.book_open_24_regular,
                                  'Lessons',
                                  unit['lessons'].length.toString(),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: _buildDetailChip(
                                  context,
                                  FluentIcons.calendar_24_regular,
                                  'Created',
                                  AppUtils.formatDate(
                                      unit['created_at'].toString()),
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
      ],
    );
  }

  Widget _buildDetailChip(
      BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isHovered ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              _isHovered ? Colors.white.withOpacity(0.3) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: _isHovered ? Colors.white : AppUtils.mainBlue(context),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: _isHovered
                        ? Colors.white.withOpacity(0.8)
                        : AppUtils.mainGrey(context),
                  ),
                ),
                const Gap(2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        _isHovered ? Colors.white : AppUtils.mainBlack(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
      context: content,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            padding: const EdgeInsets.all(28),
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtils.mainRed(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.delete_24_regular,
                    color: AppUtils.mainRed(context),
                    size: 48,
                  ),
                ),
                const Gap(20),
                Text(
                  "Delete Unit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this unit? This action cannot be undone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppUtils.mainGrey(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: AppUtils.mainGrey(context)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppUtils.mainBlack(context),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Consumer<UnitsProvider>(
                        builder: (context, unitsProvider, _) {
                          return ElevatedButton(
                            onPressed: unitsProvider.isLoading
                                ? null
                                : () {
                                    unitsProvider.deleteUnit(
                                        tokenRef, widget.unit['id']);
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      unitsProvider.fetchUserUnits(tokenRef);
                                      Navigator.pop(context);
                                    });
                                  },
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppUtils.mainRed(context),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: unitsProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context,
      {required List<Map<String, dynamic>> courses, required String token}) {
    final _formKey = GlobalKey<FormState>();

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Edit Unit",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: AppUtils.mainBlue(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  icon: const Icon(
                                      FluentIcons.dismiss_24_regular),
                                ),
                              ],
                            ),
                            const Gap(24),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(FluentIcons.class_24_regular),
                                labelText: 'Unit Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                                  ? 'Please enter unit name'
                                  : null,
                            ),
                            const Gap(16),
                            TextFormField(
                              controller: codeController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                    FluentIcons.number_circle_0_24_regular),
                                labelText: 'Unit Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                                  ? 'Please enter unit code'
                                  : null,
                            ),
                            const Gap(16),
                            TextFormField(
                              controller: courseIdController,
                              readOnly: true,
                              onTap: () =>
                                  togglesProvider.toggleCoursesDropDown(),
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
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(8),
                                constraints: BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
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
                                  children: courses.map((course) {
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color:
                                              selectedCourseId == course['id']
                                                  ? AppUtils.mainBlue(context)
                                                      .withOpacity(0.1)
                                                  : Colors.transparent,
                                        ),
                                        child: Text(course['name']),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            const Gap(16),
                            TextFormField(
                              controller: semesterController,
                              readOnly: true,
                              onTap: () =>
                                  togglesProvider.toggleSemesterDropDown(),
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
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
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
                                  children: semesters.map((semester) {
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
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
                            const Gap(24),
                            Consumer<UnitsProvider>(
                              builder: (context, unitProvider, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: unitProvider.isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              unitProvider.editUserUnit(
                                                  token, newUnit);
                                              if (unitProvider.success) {
                                                Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () => context.pop());
                                              }
                                            }
                                          },
                                    style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        unitProvider.isLoading
                                            ? Colors.grey
                                            : AppUtils.mainBlue(context),
                                      ),
                                      padding: const WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 24,
                                        ),
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
                                            'Save Changes',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
          },
        );
      },
    );
  }
}
