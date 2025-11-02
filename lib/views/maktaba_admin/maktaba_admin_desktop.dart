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
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1,
                              top: 20,
                              bottom: 20),
                          child: Column(
                            spacing: 20,
                            children: [
                              _buildTopBar(context),
                              _buildWelcomeCard(),
                              _buildStatsGrid(),
                              Expanded(child: _buildCoursesSection(),)
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
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
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
                hintText: "Search content...",
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
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.alert_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
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
                  'AD',
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

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppUtils.mainBlue(context),
            AppUtils.mainBlue(context).withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppUtils.mainBlue(context).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Welcome to Maktaba!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppUtils.mainWhite(context).withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Hello, Admin',
                style: TextStyle(
                  fontSize: 28,
                  color: AppUtils.mainWhite(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(4),
              Text(
                'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.9),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FluentIcons.book_24_regular,
              size: 48,
              color: AppUtils.mainWhite(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<CoursesProvider>(
          builder: (context, provider, _) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard(
                  'COURSES',
                  'Total: ${provider.courses.length}',
                  FluentIcons.book_24_regular,
                  Colors.blue,
                  constraints.maxWidth,
                ),
                _buildStatCard(
                  'UNITS',
                  'Total: 0',
                  FluentIcons.notebook_24_regular,
                  Colors.green,
                  constraints.maxWidth,
                ),
                _buildStatCard(
                  'STUDENTS',
                  'Total: 0',
                  FluentIcons.people_24_regular,
                  Colors.purple,
                  constraints.maxWidth,
                ),
                _buildStatCard(
                  'LESSONS',
                  'Total: 0',
                  FluentIcons.bookmark_24_regular,
                  Colors.amber,
                  constraints.maxWidth,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, double maxWidth) {
    // Calculate card width: 3 columns for wider tablets, 2 for narrower
    double cardWidth =
        maxWidth > 1200 ? (maxWidth - 48) / 4 : (maxWidth - 32) / 3;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    'Courses',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Manage your course catalog',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddDialog();
                },
                icon: Icon(FluentIcons.add_24_regular, size: 20),
                label: Text('Add Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtils.mainBlue(context),
                  foregroundColor: AppUtils.mainWhite(context),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          _buildCourseList(),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return Consumer<CoursesProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                spacing: 12,
                children: [
                  Icon(
                    FluentIcons.error_circle_24_regular,
                    color: Colors.red,
                    size: 56,
                  ),
                  Text(
                    provider.message,
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.courses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                spacing: 16,
                children: [
                  Icon(
                    FluentIcons.book_24_regular,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                  Text(
                    'No courses available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Get started by adding your first course',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Gap(8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddDialog();
                    },
                    icon: const Icon(FluentIcons.add_24_regular),
                    label: const Text('Add your first course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUtils.mainBlue(context),
                      foregroundColor: AppUtils.mainWhite(context),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            spacing: 12,
            children: provider.courses.map((course) {
              return _buildCourseItem(course);
            }).toList(),
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

    return Container(
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppUtils.mainBlue(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            FluentIcons.book_24_regular,
            color: AppUtils.mainBlue(context),
            size: 28,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            spacing: 16,
            children: [
              Row(
                spacing: 6,
                children: [
                  Icon(
                    FluentIcons.notebook_24_regular,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  Text(
                    '${unitsList.length} units',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 6,
                children: [
                  Icon(
                    FluentIcons.people_24_regular,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  Text(
                    '${studentsList.length} students',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            IconButton(
              icon: Icon(FluentIcons.edit_24_regular, size: 20),
              onPressed: () {
                _showEditDialog(course);
              },
              color: Colors.blue,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(FluentIcons.delete_24_regular, size: 20),
              onPressed: () {
                _showDeleteDialog(course['id'].toString());
              },
              color: Colors.red,
              tooltip: 'Delete',
            ),
          ],
        ),
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
            padding: const EdgeInsets.all(28),
            width: MediaQuery.of(context).size.width * 0.4,
            constraints: BoxConstraints(maxWidth: 500),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Course",
                        style: TextStyle(
                          fontSize: 22,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
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
                          if (context.mounted) {
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
            padding: const EdgeInsets.all(28),
            width: MediaQuery.of(context).size.width * 0.4,
            constraints: BoxConstraints(maxWidth: 500),
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
                          "Edit Course",
                          style: TextStyle(
                            fontSize: 22,
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                            await _coursesProvider.updateCourse(
                                token: _authProvider.token!, body: body);
                            if (context.mounted) {
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.4,
            constraints: BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtils.mainRed(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FluentIcons.delete_24_regular,
                    color: AppUtils.mainRed(context),
                    size: 48,
                  ),
                ),
                const Gap(20),
                Text(
                  "Delete Course",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainRed(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this course? This action cannot be undone.",
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const Gap(28),
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
                              borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(8),
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
