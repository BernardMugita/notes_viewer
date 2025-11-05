import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/admin/units_manager/units_manager_desktop.dart';
import 'package:maktaba/views/admin/units_manager/units_manager_mobile.dart';
import 'package:maktaba/views/admin/units_manager/units_manager_tablet.dart';

class UnitsManagerView extends StatelessWidget {
  final String? courseId;

  const UnitsManagerView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    return ResponsiveLayout(
      mobileLayout: UnitsManagerMobile(),
      tabletLayout: UnitsManagerTablet(),
      desktopLayout: UnitsManagerDesktop(courseId: courseId!),
    );
  }
}
