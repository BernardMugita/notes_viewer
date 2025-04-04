import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/auth/reset_password/change_password/desktop_change_password.dart';
import 'package:maktaba/views/auth/reset_password/change_password/mobile_change_password.dart';
import 'package:maktaba/views/auth/reset_password/change_password/tablet_change_password.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileChangePassword(),
        tabletLayout: TabletChangePassword(),
        desktopLayout: DesktopChangePassword());
  }
}
