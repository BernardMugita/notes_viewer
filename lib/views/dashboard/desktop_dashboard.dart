import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/banner/dashboard_banner.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/desktop_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: Consumer2<DashboardProvider, TogglesProvider>(builder:
          (BuildContext context, dashBoardProvider, togglesProvider, _) {
        final dashData = dashBoardProvider.dashData;

        bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

        final searchResults = togglesProvider.searchResults;

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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 10,
                    bottom: 20),
                child: dashBoardProvider.isLoading
                    ? LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.mainBlue(context),
                        size: 100,
                      )
                    : Column(
                        spacing: 10,
                        children: [
                          // if (!context
                          //     .watch<TogglesProvider>()
                          //     .isBannerDismissed)
                          //   Consumer<TogglesProvider>(
                          //       builder: (context, toggleProvider, _) {
                          //     return toggleProvider.isBannerDismissed
                          //         ? SizedBox()
                          //         : MembershipBanner();
                          //   }),
                          Row(
                            children: [
                              Spacer(),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        togglesProvider.searchAction(
                                            searchController.text,
                                            dashData['notifications']['read'],
                                            'title');
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.5),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: AppUtils.mainWhite(context),
                                        prefixIcon:
                                            Icon(FluentIcons.search_24_regular),
                                        hintText: "Search",
                                        hintStyle: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer()
                            ],
                          ),
                          if (togglesProvider.searchMode)
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                  "Search results for '${searchController.text}'"),
                            ),
                          if (togglesProvider.searchMode)
                            SearchResults(
                              searchResults: searchResults,
                              query: searchController.text,
                              target: 'title',
                            )
                          else
                            Column(
                              children: [
                                DashboardBanner(data: dashData),
                                Gap(20),
                                DesktopCardRow(
                                  users: dashData['user_count'] ?? 0,
                                  materialCount:
                                      dashData['material_count'] ?? {},
                                ),
                                Gap(20),
                                SizedBox(
                                    width: double.infinity,
                                    child: Flex(
                                        direction: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                        "Recent Activities",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppUtils
                                                                .mainGrey(
                                                                    context))),
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
                                                    child: Text(
                                                        "Activity History",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppUtils
                                                                .mainGrey(
                                                                    context))),
                                                  ),
                                                  Gap(10),
                                                  ActivityHistory(),
                                                ],
                                              )),
                                        ])),
                              ],
                            ),
                        ],
                      ),
              ))
        ]);
      }),
    );
  }
}
