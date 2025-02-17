import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/banner/dashboard_banner.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/tablet_card_row.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class TabletDashboard extends StatelessWidget {
  TabletDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print(context.read<AuthProvider>().user);

    return Scaffold(
        key: _scaffoldKey, // Attach the GlobalKey to the Scaffold
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(FluentIcons.re_order_24_regular),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: Consumer<DashboardProvider>(
            builder: (BuildContext context, dashBoardProvider, _) {
          final dashData = dashBoardProvider.dashData;

          return dashBoardProvider.isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: LoadingAnimationWidget.newtonCradle(
                    color: AppUtils.$mainBlue,
                    size: 100,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DashboardBanner(data: dashData),
                              const Gap(10),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: AppUtils.$mainWhite,
                                    prefixIcon:
                                        Icon(FluentIcons.search_24_filled),
                                    border: OutlineInputBorder(),
                                    hintText: "Search",
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),
                        TabletCardRow(
                          user: dashData['user'] ?? {},
                          users: dashData['user_count'] ?? 0,
                          materialCount: dashData['material_count'] ?? {},
                        ),
                        const Gap(20),
                        Text(
                          "Recent Activities",
                          style: TextStyle(
                              color: AppUtils.$mainGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        const DesktopActivities(),
                        const Gap(20),
                        Text(
                          "Activity History",
                          style: TextStyle(
                              color: AppUtils.$mainGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        const ActivityHistory()
                      ],
                    ),
                  ),
                );
        }));
  }
}
