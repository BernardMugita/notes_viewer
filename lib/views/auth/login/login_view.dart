import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/auth/login/desktop_login.dart';
import 'package:maktaba/views/auth/login/mobile_login.dart';
import 'package:maktaba/views/auth/login/tablet_login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileLogin(),
        tabletLayout: TabletLogin(),
        desktopLayout: DesktopLogin());
  }
}
