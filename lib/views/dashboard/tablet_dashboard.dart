import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
// import 'package:note_viewer/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:note_viewer/widgets/app_widgets/search/search_results.dart';
import 'package:note_viewer/widgets/dashboard_widgets/banner/dashboard_banner.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/tablet_card_row.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:note_viewer/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class TabletDashboard extends StatelessWidget {
  TabletDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

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
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
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
                              const Gap(10),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    togglesProvider.searchAction(
                                        searchController.text,
                                        dashData['notifications']['read'],
                                        'title');
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppUtils.mainWhite(context),
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
                        Gap(10),
                        if (togglesProvider.searchMode)
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                                "Search results for '${searchController.text}'"),
                          ),
                        Gap(10),
                        if (togglesProvider.searchMode)
                          SearchResults(
                              searchResults: searchResults,
                              query: searchController.text,
                              target: "title"),
                        const Gap(10),
                        TabletCardRow(
                          user: dashData['user'] ?? {},
                          users: dashData['user_count'] ?? 0,
                          materialCount: dashData['material_count'] ?? {},
                        ),
                        const Gap(20),
                        Text(
                          "Recent Activities",
                          style: TextStyle(
                              color: AppUtils.mainGrey(context),
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        const DesktopActivities(),
                        const Gap(20),
                        Text(
                          "Activity History",
                          style: TextStyle(
                              color: AppUtils.mainGrey(context),
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
