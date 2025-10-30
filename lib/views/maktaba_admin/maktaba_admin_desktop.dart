import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class MaktabaAdminDesktop extends StatefulWidget {
  const MaktabaAdminDesktop({super.key});

  @override
  State<MaktabaAdminDesktop> createState() => _MaktabaAdminDesktopState();
}

class _MaktabaAdminDesktopState extends State<MaktabaAdminDesktop> {
  final TextEditingController _searchController = TextEditingController();
  late CoursesProvider _coursesProvider;
  late AuthProvider _authProvider;
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourses();
    });
  }

  Future<void> _fetchCourses() async {
    await _coursesProvider.getAllCourses(token: _authProvider.token!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Consumer3<TogglesProvider, AuthProvider, CoursesProvider>(
        builder: (BuildContext context, togglesProvider, authProvider,
            coursesProvider, _) {
          bool isMinimized = togglesProvider.isSideNavMinimized;

          return authProvider.isLoading || coursesProvider.isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Lottie.asset("assets/animations/maktaba_loader.json"),
                )
              : Flex(
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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                            right: MediaQuery.of(context).size.width * 0.05,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Column(
                            spacing: 20,
                            children: [
                              _buildTopBar(context),
                              _buildPageTitle(),
                              _buildStatsCards(),
                              _buildContentManagement()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: TextField(
              controller: _searchController,
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
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search content...",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            spacing: 10,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.alert_24_regular,
                  size: 25,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 25,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(10),
              CircleAvatar(
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  'AD',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            'Manage your Arifu Library content',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return SizedBox(
      height: 145,
      child: Consumer<CoursesProvider>(
        builder: (context, provider, _) {
          return Row(
            spacing: 20,
            children: [
              Expanded(
                child: _buildStatCard(
                  'Courses',
                  provider.courses.length.toString(),
                  FluentIcons.book_24_regular,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Units',
                  '48',
                  FluentIcons.notebook_24_regular,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Students',
                  '256',
                  FluentIcons.people_24_regular,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'Lessons',
                  '182',
                  FluentIcons.class_24_regular,
                  Colors.purple,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppUtils.mainGrey(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              IconButton(
                icon: Icon(FluentIcons.more_vertical_24_regular, size: 20),
                onPressed: () {},
                color: Colors.grey,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentManagement() {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppUtils.mainGrey(context)),
      ),
      child: Column(
        spacing: 20,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddDialog();
                },
                icon: Icon(FluentIcons.add_24_regular),
                label: Text('Add Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtils.mainBlue(context),
                  foregroundColor: AppUtils.mainWhite(context),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          // Course List
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: _buildCourseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return Consumer<CoursesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.error) {
          return Center(child: Text(provider.message));
        }

        return SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              // List Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Course Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Units',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Students',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                  ],
                ),
              ),
              // List Items
              ...provider.courses.map((course) => _buildCourseItem(course)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    final name = course['name'] as String? ?? 'N/A';

    List<dynamic> studentsList = [];
    if (course['students'] is String) {
      try {
        studentsList = jsonDecode(course['students'] as String);
      } catch (e) {
        logger.e("Error decoding students JSON: $e");
      }
    } else if (course['students'] is List<dynamic>) {
      studentsList = course['students'] as List<dynamic>;
    }

    List<dynamic> unitsList = [];
    if (course['units'] is String) {
      try {
        unitsList = jsonDecode(course['units'] as String);
      } catch (e) {
        logger.e("Error decoding units JSON: $e");
      }
    } else if (course['units'] is List<dynamic>) {
      unitsList = course['units'] as List<dynamic>;
    }

    final students = studentsList.length.toString();
    final units = unitsList.length.toString();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppUtils.mainGrey(context)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(units, style: TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Text(students, style: TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 5,
              children: [
                IconButton(
                  icon: Icon(FluentIcons.edit_24_regular, size: 20),
                  onPressed: () {
                    _showEditDialog(course);
                  },
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(FluentIcons.delete_24_regular, size: 20),
                  onPressed: () {
                    _showDeleteDialog(course['id'].toString());
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _codeController = TextEditingController();
    final _courseYearController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Course",
                        style: TextStyle(
                          fontSize: 20,
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
                  const Gap(24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.book_24_regular),
                      labelText: 'Course Name',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course name' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.code_24_regular),
                      labelText: 'Course Code',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course code' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _courseYearController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.calendar_24_regular),
                      labelText: 'Course Year',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course year' : null,
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final body = {
                            'name': _nameController.text,
                            'code': _codeController.text,
                            'course_year': _courseYearController.text,
                            'img': 'maktaba.png',
                            'students': '[]',
                            'units': '[]',
                          };
                          await _coursesProvider.addCourse(
                              token: _authProvider.token!, body: body);
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppUtils.mainBlue(context),
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        ),
                      ),
                      child: Text(
                        'Add Course',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppUtils.mainWhite(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(Map<String, dynamic> course) {
    final _formKey = GlobalKey<FormState>();
    final _nameController =
        TextEditingController(text: course['name'] as String?);
    final _codeController =
        TextEditingController(text: course['code'] as String?);
    final _courseYearController =
        TextEditingController(text: course['course_year']?.toString());
    final _imageController =
        TextEditingController(text: course['img'] as String?);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Course",
                        style: TextStyle(
                          fontSize: 20,
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
                  const Gap(24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.book_24_regular),
                      labelText: 'Course Name',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course name' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.code_24_regular),
                      labelText: 'Course Code',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course code' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _courseYearController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.calendar_24_regular),
                      labelText: 'Course Year',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a course year' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(FluentIcons.image_24_regular),
                      labelText: 'Image URL',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      focusColor: AppUtils.mainBlue(context),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an image URL' : null,
                  ),
                  const Gap(24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final body = {
                            'course_id': course['id'].toString(),
                            'name': _nameController.text,
                            'code': _codeController.text,
                            'course_year': _courseYearController.text,
                            'img': _imageController.text,
                            'students': course['students'].toString(),
                            'units': course['units'].toString(),
                          };
                          logger.log(Level.info, body);
                          await _coursesProvider.updateCourse(
                              token: _authProvider.token!, body: body);
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppUtils.mainBlue(context),
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppUtils.mainWhite(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String courseId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.delete_24_regular,
                  color: AppUtils.mainRed(context),
                  size: 64,
                ),
                const Gap(16),
                Text(
                  "Delete Course",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainRed(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this course? This action cannot be undone.",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: AppUtils.mainGrey(context)),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppUtils.mainBlack(context),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Consumer<CoursesProvider>(
                        builder: (context, coursesProvider, _) {
                          return ElevatedButton(
                            onPressed: coursesProvider.isLoading
                                ? null
                                : () async {
                                    await coursesProvider.deleteCourse(
                                      token: _authProvider.token!,
                                      id: courseId,
                                    );
                                    if (context.mounted) {
                                      Navigator.of(dialogContext).pop();
                                    }
                                  },
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                coursesProvider.isLoading
                                    ? Colors.grey
                                    : AppUtils.mainRed(context),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: coursesProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainWhite(context),
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
}
