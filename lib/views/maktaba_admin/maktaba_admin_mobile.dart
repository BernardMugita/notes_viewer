import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class MaktabaAdminMobile extends StatefulWidget {
  const MaktabaAdminMobile({super.key});

  @override
  State<MaktabaAdminMobile> createState() => _MaktabaAdminMobileState();
}

class _MaktabaAdminMobileState extends State<MaktabaAdminMobile> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppUtils.backgroundPanel(context),
      appBar: AppBar(
        backgroundColor: AppUtils.mainBlue(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            FluentIcons.re_order_dots_vertical_24_regular,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
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
          const Gap(12),
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
          const Gap(16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  _buildWelcomeCard(),
                  _buildSummaryCard(),
                  _buildCoursesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: ResponsiveNav(),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppUtils.mainBlue(context),
            AppUtils.mainBlue(context).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
              fontSize: 24,
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            style: TextStyle(
              fontSize: 14,
              color: AppUtils.mainWhite(context).withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Consumer<CoursesProvider>(
            builder: (context, provider, _) {
              return Column(
                spacing: 12,
                children: [
                  _buildSummaryItem(
                    'COURSES',
                    'Total: ${provider.courses.length}',
                    FluentIcons.book_24_regular,
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'UNITS',
                    'Total: 0',
                    FluentIcons.notebook_24_regular,
                    Colors.green,
                  ),
                  _buildSummaryItem(
                    'STUDENTS',
                    'Total: 0',
                    FluentIcons.people_24_regular,
                    Colors.orange,
                  ),
                  _buildSummaryItem(
                    'LESSONS',
                    'Total: 0',
                    FluentIcons.note_24_regular,
                    Colors.purple,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  _showAddDialog();
                },
                icon: Icon(
                  FluentIcons.add_circle_24_regular,
                  color: AppUtils.mainBlue(context),
                  size: 28,
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                spacing: 12,
                children: [
                  Icon(
                    FluentIcons.error_circle_24_regular,
                    color: Colors.red,
                    size: 48,
                  ),
                  Text(
                    provider.message,
                    style: const TextStyle(fontSize: 14),
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
              padding: const EdgeInsets.all(32.0),
              child: Column(
                spacing: 12,
                children: [
                  Icon(
                    FluentIcons.book_24_regular,
                    color: Colors.grey[400],
                    size: 48,
                  ),
                  Text(
                    'No courses available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(8),
                  TextButton.icon(
                    onPressed: () {
                      _showAddDialog();
                    },
                    icon: const Icon(FluentIcons.add_24_regular),
                    label: const Text('Add your first course'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          spacing: 8,
          children: provider.courses.map((course) {
            return _buildCourseItem(course);
          }).toList(),
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppUtils.mainBlue(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            FluentIcons.book_24_regular,
            color: AppUtils.mainBlue(context),
            size: 24,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${unitsList.length} units • ${studentsList.length} students',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            FluentIcons.more_vertical_24_regular,
            color: Colors.grey[600],
          ),
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(course);
            } else if (value == 'delete') {
              _showDeleteDialog(course['id'].toString());
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    FluentIcons.edit_24_regular,
                    size: 20,
                    color: Colors.blue,
                  ),
                  const Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    FluentIcons.delete_24_regular,
                    size: 20,
                    color: Colors.red,
                  ),
                  const Text('Delete'),
                ],
              ),
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
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.9,
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
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.9,
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
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.85,
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
