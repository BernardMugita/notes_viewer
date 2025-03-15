import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class Activity extends StatefulWidget {
  final Map activity;

  const Activity({super.key, required this.activity});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // Define the variables as part of the state
  Map toggledActivity = {};
  bool isToggledActivity = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    String uploadType = activity['type'] ?? 'notes';
    final unitId = activity['unit_id'];

    return Consumer3<TogglesProvider, DashboardProvider, LessonsProvider>(
      builder: (BuildContext context, toggleProvider, dashboardProvider,
          lessonProvider, _) {
        List dashUnits = dashboardProvider.dashData['units'];
        final unit = dashUnits.firstWhere((unit) {
          return unit['id'] == unitId;
        });
        List lessons = unit['lessons'].isNotEmpty ? unit['lessons'] : [];

        if (uploadType != '' &&
            uploadType.isNotEmpty &&
            uploadType == 'recordings') {
          uploadType = uploadType.substring(0, uploadType.length - 1);
        }

        final activityLesson = lessons.isNotEmpty
            ? lessons.firstWhere((lesson) {
                String lessonName = lesson['name'].toString().toLowerCase();
                String activityLessonName = activity['message']
                    .toString()
                    .split(uploadType)[0]
                    .replaceAll('-', '')
                    .toLowerCase();

                return lessonName.replaceAll(' ', '') ==
                    activityLessonName.replaceAll(' ', '');
              })
            : null;

        Future<void> getLessonDetailsFromActivityLesson() async {
          await lessonProvider.getLesson(tokenRef, activityLesson['id']);
        }

        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: AppUtils.mainWhite(context),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<UnitsProvider>().setUnitId(unitId);
                      context.go('/units/notes');
                    },
                    child: Text(
                      activity['title'] ?? 'Loading . . .',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      toggleProvider.toggleIsActivityExpanded();
                      await getLessonDetailsFromActivityLesson();
                      setState(() {
                        if (toggledActivity.isNotEmpty) {
                          toggledActivity = {};
                        } else {
                          toggledActivity = activity;
                        }
                        isToggledActivity =
                            toggledActivity['id'] == widget.activity['id'];
                      });
                    },
                    child:
                        (toggleProvider.isActivityExpanded && isToggledActivity)
                            ? Icon(FluentIcons.chevron_up_24_filled)
                            : Icon(FluentIcons.chevron_down_24_filled),
                  )
                ],
              ),
              if (toggleProvider.isActivityExpanded && isToggledActivity)
                Column(
                  children: [
                    Divider(
                      color: AppUtils.mainBlueAccent(context),
                      indent: 10,
                    ),
                    ListTile(
                      onTap: () {
                        String url = AppUtils.$serverDir;
                        Map lesson = lessonProvider.lesson;
                        Map filteredMaterial =
                            (lesson['materials'][uploadType] as List)
                                .firstWhere((material) {
                          return material['id'] == activity['material_id'];
                        });
                        context.go(
                            '/units/notes/${lesson['name']}/${filteredMaterial['file'].toString().split('/').last}',
                            extra: {
                              "path": "$url/${filteredMaterial['file']}",
                              "material": filteredMaterial,
                              "featured_material": lesson['materials']
                                  [uploadType],
                            });
                      },
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      title: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: uploadType == 'notes'
                                    ? Colors.purpleAccent.withOpacity(0.2)
                                    : uploadType == 'slides'
                                        ? Colors.amber.withOpacity(0.2)
                                        : uploadType == 'recordings'
                                            ? AppUtils.mainBlue(context)
                                                .withOpacity(0.2)
                                            : uploadType ==
                                                    "student_contributions"
                                                ? Colors.deepOrange
                                                    .withOpacity(0.2)
                                                : AppUtils.mainGreen(context)
                                                    .withOpacity(0.2),
                                child: Icon(
                                  uploadType == 'notes'
                                      ? FluentIcons.book_24_regular
                                      : uploadType == 'slides'
                                          ? FluentIcons.slide_content_24_regular
                                          : uploadType == 'recordings'
                                              ? FluentIcons.video_24_regular
                                              : uploadType ==
                                                      "student_contributions"
                                                  ? FluentIcons
                                                      .people_20_regular
                                                  : FluentIcons
                                                      .person_24_regular,
                                  color: uploadType == 'notes'
                                      ? Colors.purpleAccent
                                      : uploadType == 'slides'
                                          ? Colors.amber
                                          : uploadType == 'recordings'
                                              ? AppUtils.mainBlue(context)
                                              : uploadType ==
                                                      "student_contributions"
                                                  ? Colors.deepOrange
                                                  : AppUtils.mainGreen(context),
                                ),
                              ),
                              Gap(10),
                              Expanded(child: Text(activity['message'])),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
