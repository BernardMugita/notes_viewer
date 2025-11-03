import 'package:flutter/cupertino.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/units_manager/units_manager_desktop.dart';
import 'package:maktaba/views/units_manager/units_manager_mobile.dart';
import 'package:maktaba/views/units_manager/units_manager_tablet.dart';

class UnitsManagerView extends StatelessWidget {
  final String? courseId;

  const UnitsManagerView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: UnitsManagerMobile(),
      tabletLayout: UnitsManagerTablet(),
      desktopLayout: UnitsManagerDesktop(),
    );
  }
}
