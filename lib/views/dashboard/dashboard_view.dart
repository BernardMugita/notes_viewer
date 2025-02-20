import 'package:flutter/material.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/dashboard/desktop_dashboard.dart';
import 'package:note_viewer/views/dashboard/mobile_dashboard.dart';
import 'package:note_viewer/views/dashboard/tablet_dashboard.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final dashboardProvider = context.read<DashboardProvider>();

      final String token = authProvider.token ?? '';

      if (token.isNotEmpty) {
        tokenRef = token;
        dashboardProvider.fetchDashData(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ResponsiveLayout(
        mobileLayout: MobileDashboard(),
        tabletLayout: TabletDashboard(),
        desktopLayout: DesktopDashboard());
  }
}
