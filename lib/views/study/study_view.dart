import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/study/desktop_study.dart';
import 'package:maktaba/views/study/mobile_study.dart';
import 'package:maktaba/views/study/tablet_study.dart';
import 'package:provider/provider.dart';

class StudyView extends StatefulWidget {
  final String lesson;

  const StudyView({super.key, required this.lesson});

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileLayout: MobileStudy(),
        tabletLayout: TabletStudy(),
        desktopLayout: DesktopStudy(),
      ),
    );
  }
}
