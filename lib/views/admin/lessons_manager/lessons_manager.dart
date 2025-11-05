import 'package:flutter/cupertino.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/admin/lessons_manager/lessons_manager_desktop.dart';

class LessonsManagerView extends StatelessWidget {
  final String? unitId;

  const LessonsManagerView({super.key, required this.unitId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: LessonsManagerDesktop(unitId: unitId!),
      tabletLayout: LessonsManagerDesktop(unitId: unitId!),
      desktopLayout: LessonsManagerDesktop(unitId: unitId!),
    );
  }
}
