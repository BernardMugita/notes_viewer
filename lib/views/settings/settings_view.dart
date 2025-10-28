import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/settings/desktop_settings.dart';
import 'package:maktaba/views/settings/mobile_settings.dart';
import 'package:maktaba/views/settings/tablet_settings.dart';

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
