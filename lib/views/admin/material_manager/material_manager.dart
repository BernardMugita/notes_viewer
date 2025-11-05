import 'package:flutter/cupertino.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/admin/material_manager/material_manager_desktop.dart';

class MaterialManagerView extends StatelessWidget {
  final String? lessonId;

  const MaterialManagerView({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: MaterialManagerDesktop(lessonId: lessonId!),
      tabletLayout: MaterialManagerDesktop(lessonId: lessonId!),
      desktopLayout: MaterialManagerDesktop(lessonId: lessonId!),
    );
  }
}
