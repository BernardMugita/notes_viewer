import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/admin/maktaba_admin/maktaba_admin_desktop.dart';
import 'package:maktaba/views/admin/maktaba_admin/maktaba_admin_mobile.dart';
import 'package:maktaba/views/admin/maktaba_admin/maktaba_admin_tablet.dart';

class MaktabaAdminView extends StatelessWidget {
  const MaktabaAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileLayout: MaktabaAdminMobile(),
      tabletLayout: MaktabaAdminTablet(),
      desktopLayout: MaktabaAdminDesktop(),
    );
  }
}