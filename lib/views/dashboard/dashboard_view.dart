import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/dashboard/desktop_dashboard.dart';
import 'package:note_viewer/views/dashboard/mobile_dashboard.dart';
import 'package:note_viewer/views/dashboard/tablet_dashboard.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileDashboard(),
        tabletLayout: TabletDashboard(),
        desktopLayout: DesktopDashboard());
  }
}
