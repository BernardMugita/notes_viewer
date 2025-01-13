import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/study/desktop_study.dart';
import 'package:note_viewer/views/study/mobile_study.dart';
import 'package:note_viewer/views/study/tablet_study.dart';

class StudyView extends StatefulWidget {
  final String lesson;

  const StudyView({super.key, required this.lesson});

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> {
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
