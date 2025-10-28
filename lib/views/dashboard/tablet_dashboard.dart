import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/confirm_exit.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/tablet_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_progress/recent_progress.dart';
import 'package:provider/provider.dart';

class TabletDashboard extends StatefulWidget {
  const TabletDashboard({super.key});

  @override
  State<TabletDashboard> createState() => _TabletDashboardState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _TabletDashboardState extends State<TabletDashboard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    TabController controller = TabController(length: 2, vsync: this);

    final dashData = context.read<DashboardProvider>().dashData;

    bool isNewActivities =
        dashData.isNotEmpty && dashData['notifications'].isNotEmpty
            ? dashData['notifications']!['unread']!.isNotEmpty
            : false;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmExit(),
        );

        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppUtils.backgroundPanel(context),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppUtils.mainBlue(context),
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              FluentIcons.re_order_24_regular,
              color: AppUtils.mainWhite(context),
            ),
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
                    spacing: 20,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppUtils.mainBlue(context),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  togglesProvider.searchAction(
                                    searchController.text,
                                    dashData['notifications']['read'],
                                    'title',
                                  );
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12.5),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppUtils.mainWhite(context),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppUtils.mainWhite(context),
                                      width: 2,
                                    ),
                                  ),
                                  filled: false,
                                  prefixIcon: Icon(
                                    FluentIcons.search_24_regular,
                                    color: AppUtils.mainWhite(context)
                                        .withOpacity(0.8),
                                  ),
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainWhite(context)
                                          .withOpacity(0.8)),
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      FluentIcons.alert_24_regular,
                                      size: 25,
                                      color: AppUtils.mainWhite(context),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: isNewActivities
                                              ? AppUtils.mainRed(context)
                                              : AppUtils.mainGrey(context),
                                        ))
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      context.go('/settings');
                                    },
                                    icon: Icon(
                                      FluentIcons.settings_24_regular,
                                      size: 25,
                                      color: AppUtils.mainWhite(context),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (togglesProvider.searchMode)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                  "Search results for '${searchController.text}'"),
                            ),
                            SearchResults(
                                searchResults: searchResults,
                                query: searchController.text,
                                target: "title"),
                          ],
                        ),
                      if (!togglesProvider.searchMode)
                        Column(
                          spacing: 20,
                          children: [
                            TabletCardRow(
                              user: dashData['user'] ?? {},
                              users: dashData['user_count'] ?? 0.0,
                              materialCount: dashData['material_count'] ?? {},
                            ),
                            SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.45,
                              child: RecentProgress(),
                            ),
                            Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppUtils.mainWhite(context),
                                    border: Border.all(
                                      color: AppUtils.mainGrey(context),
                                    )),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    TabBar(
                                      indicatorWeight: 3,
                                      dividerColor: AppUtils.mainGrey(context),
                                      indicatorColor:
                                          AppUtils.mainBlue(context),
                                      // indicatorSize: TabBarIndicatorSize.tab,
                                      labelColor: AppUtils.mainBlue(context),
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      unselectedLabelColor:
                                          AppUtils.mainGrey(context),
                                      controller: controller,
                                      tabs: [
                                        Tab(
                                            child: Row(
                                          spacing: 10,
                                          children: [
                                            Icon(FluentIcons.clock_24_regular),
                                            Text("Recent Activities"),
                                          ],
                                        )),
                                        Tab(
                                            child: Row(
                                          spacing: 10,
                                          children: [
                                            Icon(
                                                FluentIcons.history_24_regular),
                                            Text("Activity History"),
                                          ],
                                        )),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.325,
                                      child: TabBarView(
                                          controller: controller,
                                          children: [
                                            DesktopActivities(),
                                            ActivityHistory(),
                                          ]),
                                    )
                                  ],
                                ))
                          ],
                        )
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
