import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class LessonsManagerDesktop extends StatefulWidget {
  final String unitId;

  const LessonsManagerDesktop({super.key, required this.unitId});

  @override
  State<LessonsManagerDesktop> createState() => _LessonsManagerDesktopState();
}

class _LessonsManagerDesktopState extends State<LessonsManagerDesktop> {
  final TextEditingController _searchController = TextEditingController();
  Logger logger = Logger();

  String tokenRef = '';
  String lessonId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<LessonsProvider>().getAllLesson(tokenRef, widget.unitId);
      }
    });
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
      body: Consumer3<TogglesProvider, AuthProvider, LessonsProvider>(
        builder: (BuildContext context, togglesProvider, authProvider,
            lessonsProvider, _) {
          bool isMinimized = togglesProvider.isSideNavMinimized;

          return authProvider.isLoading || lessonsProvider.isLoading
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
                            children: [
                              _buildTopBar(context),
                              const Gap(20),
                              Expanded(
                                child: _buildLessonsSection(),
                              )
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              FluentIcons.arrow_left_24_regular,
              color: AppUtils.mainWhite(context),
              size: 24,
            ),
            tooltip: 'Back to Units',
          ),
          const Gap(12),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                hintText: "Search lessons...",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
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
              const Gap(8),
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

  Widget _buildLessonsSection() {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lessons',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Manage unit lessons',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddLessonDialog();
                },
                icon: const Icon(FluentIcons.add_24_regular, size: 20),
                label: const Text('Add Lesson'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtils.mainBlue(context),
                  foregroundColor: AppUtils.mainWhite(context),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(child: _buildLessonsList()),
        ],
      ),
    );
  }

  Widget _buildLessonsList() {
    return Consumer<LessonsProvider>(
      builder: (context, lessonsProvider, _) {
        if (lessonsProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (lessonsProvider.lessons.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Icon(
                    FluentIcons.book_24_regular,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                  const Gap(16),
                  Text(
                    'No lessons available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Get started by adding your first lesson',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Gap(8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddLessonDialog();
                    },
                    icon: const Icon(FluentIcons.add_24_regular),
                    label: const Text('Add your first lesson'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUtils.mainBlue(context),
                      foregroundColor: AppUtils.mainWhite(context),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: lessonsProvider.lessons.asMap().entries.map((entry) {
              return _buildLessonItem(entry.value, entry.key);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildLessonItem(dynamic lesson, int index) {
    final name = lesson['name'] as String? ?? 'N/A';
    final files = lesson['files'] as Map<String, dynamic>?;

    int materialCount = 0;
    if (files != null) {
      materialCount += (files['notes'] as List?)?.length ?? 0;
      materialCount += (files['slides'] as List?)?.length ?? 0;
      materialCount += (files['recordings'] as List?)?.length ?? 0;
      materialCount += (files['contributions'] as List?)?.length ?? 0;
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          context.go(
              '/maktaba_admin/units_manager/${GoRouter.of(context).state!.pathParameters['courseId']}/lessons_manager/${widget.unitId}/material_manager/${lesson['id']}');
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            FluentIcons.book_24_regular,
            color: Colors.purple,
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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '$materialCount Materials',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(FluentIcons.edit_24_regular, size: 20),
              onPressed: () {
                // _showEditLessonDialog(lesson, index);
              },
              color: Colors.blue,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(FluentIcons.delete_24_regular, size: 20),
              onPressed: () {
                lessonId = lesson['id'];
                // _showDeleteLessonDialog(index);
              },
              color: Colors.red,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLessonDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                              "Add New Lesson",
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

                        // Lesson Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(FluentIcons.class_24_regular),
                            labelText: 'Lesson Name',
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
                              ? 'Please enter a lesson name'
                              : null,
                        ),
                        const Gap(24),

                        // Submit Button
                        Consumer<LessonsProvider>(
                            builder: (context, lessonProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: lessonProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await lessonProvider
                                            .createNewLesson(
                                          tokenRef,
                                          _nameController.text,
                                          widget.unitId,
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
                                  lessonProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                ),
                              ),
                              child: lessonProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Add Lesson',
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
              if (context.watch<LessonsProvider>().success)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SuccessWidget(
                      message: context.watch<LessonsProvider>().message),
                )
              else if (context.watch<LessonsProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<LessonsProvider>().message),
                )
            ],
          );
        });
      },
    );
  }
}
