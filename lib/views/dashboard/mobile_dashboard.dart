import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/banner/dashboard_banner.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/mobile_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class MobileDashboard extends StatelessWidget {
  MobileDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      key: _scaffoldKey, // Attach the global key to the Scaffold
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(FluentIcons.re_order_24_regular),
        ),
      ),
      drawer: const ResponsiveNav(),
      body: Consumer2<DashboardProvider, TogglesProvider>(builder:
          (BuildContext context, dashBoardProvider, togglesProvider, _) {
        final dashData = dashBoardProvider.dashData;

        final searchResults = togglesProvider.searchResults;

        return dashBoardProvider.isLoading
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: LoadingAnimationWidget.newtonCradle(
                  color: AppUtils.mainBlue(context),
                  size: 100,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    // if (!context
                    //           .watch<TogglesProvider>()
                    //           .isBannerDismissed)
                    //         Consumer<TogglesProvider>(
                    //         builder: (context, toggleProvider, _) {
                    //       return toggleProvider.isBannerDismissed
                    //           ? SizedBox()
                    //           : MembershipBanner();
                    //     }),
                    if (!togglesProvider.searchMode)
                      DashboardBanner(data: dashData),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                togglesProvider.searchAction(
                                    searchController.text,
                                    dashData['notifications']['read'],
                                    'title');
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                filled: true,
                                fillColor: AppUtils.mainWhite(context),
                                prefixIcon: Icon(FluentIcons.search_24_regular),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppUtils.mainGrey(context)),
                                    borderRadius: BorderRadius.circular(5)),
                                hintText: "Search",
                                hintStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                          target: "title"),
                    MobileCardRow(
                      user: dashData['user'] ?? {},
                      users: dashData['user_count'] ?? 0.0,
                      materialCount: dashData['material_count'] ?? {},
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text("Recent Activities",
                          style: TextStyle(color: AppUtils.mainGrey(context)),
                          textAlign: TextAlign.left),
                    ),
                    const DesktopActivities(),
                    SizedBox(
                      width: double.infinity,
                      child: Text("Activity History",
                          style: TextStyle(color: AppUtils.mainGrey(context)),
                          textAlign: TextAlign.left),
                    ),
                    const ActivityHistory()
                  ],
                ),
              );
      }),
    );
  }
}
