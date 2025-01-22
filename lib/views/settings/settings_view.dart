import 'package:flutter/material.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/settings/desktop_settings.dart';
import 'package:note_viewer/views/settings/mobile_settings.dart';
import 'package:note_viewer/views/settings/tablet_settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileSettings(),
        tabletLayout: TabletSettings(),
        desktopLayout: DesktopSettings());
  }
}
