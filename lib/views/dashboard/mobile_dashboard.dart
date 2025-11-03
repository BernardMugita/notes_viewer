import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/confirm_exit.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/mobile_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_progress/recent_progress.dart';
import 'package:provider/provider.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({super.key});

  @override
  State<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
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
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              FluentIcons.re_order_dots_vertical_24_regular,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                FluentIcons.alert_24_regular,
                size: 24,
                color: AppUtils.mainWhite(context),
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/settings');
              },
              icon: Icon(
                FluentIcons.settings_24_regular,
                size: 24,
                color: AppUtils.mainWhite(context),
              ),
            ),
            const Gap(12),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppUtils.mainWhite(context),
              child: Text(
                user.isNotEmpty ? user['username'][0].toUpperCase() : 'G',
                style: TextStyle(
                  color: AppUtils.mainBlue(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const Gap(16),
          ],
        ),
        drawer: const ResponsiveNav(),
        body: Consumer2<DashboardProvider, TogglesProvider>(
          builder:
              (BuildContext context, dashBoardProvider, togglesProvider, _) {
            final dashData = dashBoardProvider.dashData;
            final searchResults = togglesProvider.searchResults;
            bool isNewActivities =
                dashData.isNotEmpty && dashData['notifications'].isNotEmpty
                    ? dashData['notifications']!['unread']!.isNotEmpty
                    : false;

            return dashBoardProvider.isLoading
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: AppUtils.mainBlue(context),
                      size: 100,
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 20,
                      children: [
                        _buildTopBar(context, togglesProvider, dashData,
                            isNewActivities),
                        if (togglesProvider.searchMode)
                          _buildSearchResults(searchResults),
                        if (!togglesProvider.searchMode) ...[
                          // _buildWelcomeSection(dashData),
                          _buildStatsCards(dashData),
                          _buildRecentProgress(),
                          _buildActivitiesSection(),
                        ],
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TogglesProvider togglesProvider,
      Map<dynamic, dynamic> dashData, bool isNewActivities) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        togglesProvider.searchAction(
          _searchController.text,
          dashData['notifications']['read'],
          'title',
        );
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppUtils.mainGrey(context).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppUtils.mainBlue(context),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppUtils.mainWhite(context),
        prefixIcon: Icon(
          FluentIcons.search_24_regular,
          color: AppUtils.mainGrey(context).withOpacity(0.8),
        ),
        hintText: "Search maktaba...",
        hintStyle: TextStyle(
          fontSize: 15,
          color: AppUtils.mainGrey(context).withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(Map<dynamic, dynamic> dashData) {
    final user = dashData['user'] ?? {};
    final userName = user['name'] ?? 'User';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppUtils.mainBlue(context),
            AppUtils.mainBlue(context).withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppUtils.mainBlue(context).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppUtils.mainWhite(context).withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Hello, $userName',
                  style: TextStyle(
                    fontSize: 28,
                    color: AppUtils.mainWhite(context),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4),
                Text(
                  'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppUtils.mainWhite(context).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FluentIcons.home_24_regular,
              size: 48,
              color: AppUtils.mainWhite(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(Map<dynamic, dynamic> dashData) {
    return MobileCardRow(
      user: dashData['user'] ?? {},
      users: dashData['user_count'] ?? 0.0,
      materialCount: dashData['material_count'] ?? {},
    );
  }

  Widget _buildRecentProgress() {
    return RecentProgress();
  }

  Widget _buildActivitiesSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppUtils.mainGrey(context).withOpacity(0.3),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              indicatorColor: AppUtils.mainBlue(context),
              labelColor: AppUtils.mainBlue(context),
              labelStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelColor: Colors.grey[600],
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(FluentIcons.clock_24_regular, size: 14),
                      Text("Recent Activities"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(FluentIcons.history_24_regular, size: 14),
                      Text("Activity History"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: DesktopActivities(),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: ActivityHistory(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> searchResults) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              Icon(
                FluentIcons.search_24_regular,
                color: AppUtils.mainBlue(context),
                size: 24,
              ),
              Gap(12),
              Text(
                "Search results for '${_searchController.text}'",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SearchResults(
            searchResults: searchResults,
            query: _searchController.text,
            target: "title",
          ),
        ],
      ),
    );
  }
}
