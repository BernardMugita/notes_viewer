import 'package:flutter/cupertino.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/views/landing_page/landing_page_desktop.dart';
import 'package:maktaba/views/landing_page/landing_page_mobile.dart';
import 'package:maktaba/views/landing_page/landing_page_tablet.dart';

class LandingPageView extends StatelessWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileLayout: LandingPageMobile(),
      tabletLayout: LandingPageTablet(),
      desktopLayout: LandingPageDesktop(),
    );
  }
}
