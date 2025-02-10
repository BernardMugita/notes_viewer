import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/banner/desktop_banner.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/desktop_card_row.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardProvider>(
          builder: (BuildContext context, dashBoardProvider, _) {
        final dashData = dashBoardProvider.dashData;

        bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

        return Flex(direction: Axis.horizontal, children: [
          isMinimized
              ? Expanded(
                  flex: 1,
                  child: SideNavigation(),
                )
              : SizedBox(
                  width: 80,
                  child: SideNavigation(),
                ),
          Expanded(
              flex: 6,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 20),
                  child: dashBoardProvider.isLoading
                      ? LoadingAnimationWidget.newtonCradle(
                          color: AppUtils.$mainBlue,
                          size: 100,
                        )
                      : Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Spacer(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(12.5),
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: AppUtils.$mainWhite,
                                            prefixIcon: Icon(
                                                FluentIcons.search_24_regular),
                                            hintText: "Search",
                                            hintStyle: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Gap(20),
                              DesktopBanner(data: dashData),
                              Gap(20),
                              DesktopCardRow(
                                users: dashData['user_count'] ?? 0,
                                materialCount: dashData['material_count'] ?? {},
                              ),
                              Gap(20),
                              Expanded(
                                  // width: double.infinity,
                                  child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text("Recent Activities",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppUtils.$mainGrey)),
                                            ),
                                            Gap(10),
                                            DesktopActivities(),
                                          ],
                                        )),
                                    Gap(20),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text("Activity History",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppUtils.$mainGrey)),
                                            ),
                                            Gap(10),
                                            ActivityHistory(),
                                          ],
                                        )),
                                  ]))
                            ],
                          ),
                        )))
        ]);
      }),
    );
  }
}
