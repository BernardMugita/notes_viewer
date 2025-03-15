import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class DesktopCourse extends StatefulWidget {
  const DesktopCourse({super.key});

  @override
  State<DesktopCourse> createState() => _DesktopCourseState();
}

class _DesktopCourseState extends State<DesktopCourse> {
  List courses = [];
  Map selectedCourse = {};

  TextEditingController courseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final token = await authProvider.getToken();

        if (token != null) {
          final coursesProvider =
              Provider.of<CoursesProvider>(context, listen: false);
          await coursesProvider.fetchCourses(token: token);

          setState(() {
            courses = coursesProvider.courses;
          });
        } else {
          setState(() {
            courses = [];
          });
        }
      } catch (e) {
        // Handle errors
        print('Error fetching courses: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final togglesProvider = context.watch<TogglesProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  "Select a course to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Select a course from the drop down below to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                child: TextField(
                  controller: courseController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppUtils.mainWhite(context),
                    prefixIcon: const Icon(FluentIcons.book_24_regular),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        togglesProvider.toggleCoursesDropDown();
                      },
                      child: togglesProvider.showCoursesDropDown
                          ? const Icon(FluentIcons.chevron_up_24_regular)
                          : const Icon(FluentIcons.chevron_down_24_regular),
                    ),
                    labelText: 'Course name',
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 212, 212, 212))),
                    focusColor: AppUtils.mainBlue(context),
                  ),
                ),
              ),
              const Gap(10),
              if (togglesProvider.showCoursesDropDown)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppUtils.mainWhite(context),
                    boxShadow: [
                      BoxShadow(
                        color: AppUtils.mainShaddow(context),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: courses.map<Widget>((course) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            courseController.text = course['name'];
                            selectedCourse = course;
                            togglesProvider.toggleCoursesDropDown();
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(
                              color: Color.fromARGB(255, 209, 209, 209),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ||
                          courseController.text.isEmpty
                      ? null
                      : () async {
                          final token = await authProvider.getToken();
                          if (token != null && selectedCourse.isNotEmpty) {
                            authProvider.updateCourse(
                                token, selectedCourse['id']);
                            if (mounted) {
                              Future.delayed(const Duration(seconds: 3), () {
                                context.go('/dashboard');
                              });
                            }
                          }
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      authProvider.isLoading
                          ? AppUtils.mainGrey(context)
                          : AppUtils.mainBlue(context),
                    ),
                    padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10)),
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 16, color: AppUtils.mainWhite(context)),
                        ),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: context.watch<TogglesProvider>().rememberSelection,
                    onChanged: (bool? toggle) {
                      context.read<TogglesProvider>().toggleRememberSelection();
                    },
                  ),
                  const Gap(5),
                  const Text(
                    "Remember my selection? ",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
