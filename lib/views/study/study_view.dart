import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/study/desktop_study.dart';
import 'package:note_viewer/views/study/mobile_study.dart';
import 'package:note_viewer/views/study/tablet_study.dart';

class StudyView extends StatelessWidget {
  const StudyView({super.key});

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
