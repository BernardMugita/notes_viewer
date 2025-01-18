import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_file.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_recording.dart';
import 'package:provider/provider.dart';

class DesktopStudy extends StatefulWidget {
  const DesktopStudy({super.key});

  @override
  State<DesktopStudy> createState() => _DesktopStudyState();
}

class _DesktopStudyState extends State<DesktopStudy> {
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve token and unitId from providers
      final authProvider = context.read<AuthProvider>();
      final lessonsProvider = context.read<LessonsProvider>();

      final String token = authProvider.token ?? '';
      final state = GoRouter.of(context).state;
      final lessonId =
          state!.extra != null ? (state.extra as Map)['lesson_id'] : null;

      if (lessonId.isNotEmpty) {
        lessonsProvider.getLesson(token, lessonId);
      }

      if (token.isNotEmpty) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = context.watch<LessonsProvider>().lesson;

    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: const SideNavigation(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: context.watch<LessonsProvider>().isLoading
                  ? LoadingAnimationWidget.newtonCradle(
                      color: AppUtils.$mainBlue, size: 100)
                  : Column(
                      children: [
                        Row(
                          children: [
                            const Gap(5),
                            Text(
                              lesson['name'] ?? "Lesson name",
                              style: TextStyle(
                                fontSize: 30,
                                color: AppUtils.$mainBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              FluentIcons.doctor_24_regular,
                              size: 34,
                              color: AppUtils.$mainBlue,
                            ),
                          ],
                        ),
                        const Gap(10),
                        const Divider(
                          color: Color(0xFFCECECE),
                        ),
                        const Gap(20),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 1.25,
                          padding: const EdgeInsets.only(
                              top: 40, bottom: 40, left: 80, right: 80),
                          decoration: BoxDecoration(color: AppUtils.$mainWhite),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Study material",
                                  style: TextStyle(
                                      fontSize: 24, color: AppUtils.$mainGrey)),
                              const Gap(5),
                              Divider(
                                color: AppUtils.$mainGrey,
                              ),
                              const Gap(20),
                              if (lesson.isEmpty ||
                                  lesson['files']['notes'].isEmpty ||
                                  lesson['files']['slides'].isEmpty ||
                                  lesson['files']['recordings'].isEmpty ||
                                  lesson['files']['assignments'].isEmpty)
                                Expanded(
                                    child: Center(
                                  child: Container(
                                    width: 400,
                                    height: 400,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppUtils.$mainBlueAccent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.prohibited_24_regular,
                                          size: 100,
                                          color: Colors.orange,
                                        ),
                                        Gap(20),
                                        Text("How Empty!",
                                            style: TextStyle(fontSize: 20)),
                                        Gap(10),
                                        Text(
                                          "There's no study material for this lesson",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              else
                                Wrap(
                                  spacing: 40,
                                  runSpacing: 40,
                                  children: [
                                    lesson['files']['notes'].map((notes) {
                                      DesktopFile(
                                        fileName: '',
                                        icon:
                                            FluentIcons.document_pdf_24_regular,
                                      );
                                    }),
                                    lesson['files']['slides'].map((slides) {
                                      DesktopFile(
                                        fileName: '',
                                        icon:
                                            FluentIcons.slide_layout_24_regular,
                                      );
                                    }),
                                    lesson['files']['recordings'].map((record) {
                                      DesktopRecording(
                                        fileName: '',
                                        icon: FluentIcons.play_24_filled,
                                      );
                                    }),
                                    lesson['files']['assignments'].map((notes) {
                                      DesktopRecording(
                                        fileName: '',
                                        icon: FluentIcons.play_24_filled,
                                      );
                                    }),
                                  ],
                                ),
                            ],
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
}
