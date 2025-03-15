import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/units/desktop_units.dart';
import 'package:maktaba/views/units/mobile_units.dart';
import 'package:maktaba/views/units/tablet_units.dart';

class UnitsView extends StatelessWidget {
  const UnitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileUnits(),
        tabletLayout: TabletUnits(),
        desktopLayout: DesktopUnits());
  }
}
