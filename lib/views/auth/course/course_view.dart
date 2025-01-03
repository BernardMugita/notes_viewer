import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/auth/course/desktop_course.dart';
import 'package:note_viewer/views/auth/course/mobile_course.dart';
import 'package:note_viewer/views/auth/course/tablet_course.dart';

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobileLayout: MobileCourse(),
        tabletLayout: TabletCourse(),
        desktopLayout: DesktopCourse());
  }
}
