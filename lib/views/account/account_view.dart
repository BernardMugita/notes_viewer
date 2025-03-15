import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/account/desktop_account.dart';
import 'package:maktaba/views/account/mobile_account.dart';
import 'package:maktaba/views/account/tablet_account.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileAccount(),
        tabletLayout: TabletAccount(),
        desktopLayout: DesktopAccount());
  }
}
