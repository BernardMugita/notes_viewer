import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';

// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/desktop_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_progress/recent_progress.dart';
import 'package:provider/provider.dart';
import 'package:redacted/redacted.dart';

class DesktopDashboard extends StatefulWidget {
  const DesktopDashboard({super.key});

  @override
  State<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    TabController controller = TabController(length: 2, vsync: this);
    Logger logger = Logger();

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Consumer2<DashboardProvider, TogglesProvider>(builder:
          (BuildContext context, dashBoardProvider, togglesProvider, _) {
        final dashData = dashBoardProvider.dashData;

        logger.log(Level.info, dashData);

        bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

        final searchResults = togglesProvider.searchResults;

        bool isNewActivities =
            dashData.isNotEmpty && dashData['notifications'].isNotEmpty
                ? dashData['notifications']!['unread']!.isNotEmpty
                : false;

        return dashBoardProvider.isLoading
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Lottie.asset("assets/animations/maktaba_loader.json"),
              )
            : Flex(direction: Axis.horizontal, children: [
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            right: MediaQuery.of(context).size.width * 0.1,
                            top: 20,
                            bottom: 20),
                        child: Column(
                          spacing: 20,
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppUtils.mainBlue(context),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
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
                                                    : AppUtils.mainGrey(
                                                        context),
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
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.41,
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      spacing: 20,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: DesktopCardRow(
                                            users: dashData['user_count'] ?? 0,
                                            materialCount:
                                                dashData['material_count'] ??
                                                    {},
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2, child: RecentProgress())
                                      ],
                                    ),
                                  ),
                                  Gap(20),
                                  Container(
                                      padding: EdgeInsets.all(20),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppUtils.mainWhite(context),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppUtils.mainGrey(context)),
                                      ),
                                      child: Column(
                                        spacing: 10,
                                        children: [
                                          TabBar(
                                            indicatorWeight: 3,
                                            dividerColor:
                                                AppUtils.mainGrey(context),
                                            indicatorColor:
                                                AppUtils.mainBlue(context),
                                            indicatorSize:
                                                TabBarIndicatorSize.tab,
                                            labelColor:
                                                AppUtils.mainBlue(context),
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
                                                  Icon(FluentIcons
                                                      .clock_24_regular),
                                                  Text("Recent Activities"),
                                                ],
                                              )),
                                              Tab(
                                                  child: Row(
                                                spacing: 10,
                                                children: [
                                                  Icon(FluentIcons
                                                      .history_24_regular),
                                                  Text("Activity History"),
                                                ],
                                              )),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: AppUtils.mainGrey(
                                                        context))),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.325,
                                            child: TabBarView(
                                                controller: controller,
                                                children: [
                                                  DesktopActivities(),
                                                  ActivityHistory(),
                                                ]),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                          ],
                        ).redacted(
                            context: context,
                            redact: dashBoardProvider.isLoading),
                      ),
                    ))
              ]);
      }),
    );
  }
}
