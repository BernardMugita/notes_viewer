import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/search/search_results.dart';
import 'package:maktaba/widgets/dashboard_widgets/card_row/desktop_card_row.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity_history.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_progress/recent_progress.dart';
import 'package:provider/provider.dart';

class DesktopDashboard extends StatefulWidget {
  const DesktopDashboard({super.key});

  @override
  State<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard>
    with TickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Consumer2<DashboardProvider, TogglesProvider>(
        builder: (BuildContext context, dashBoardProvider, togglesProvider, _) {
          final dashData = dashBoardProvider.dashData;
          bool isMinimized = togglesProvider.isSideNavMinimized;
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
              : Flex(
                  direction: Axis.horizontal,
                  children: [
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
                              _buildTopBar(context, togglesProvider, dashData,
                                  isNewActivities),
                              if (togglesProvider.searchMode)
                                _buildSearchResults(searchResults),
                              if (!togglesProvider.searchMode) ...[
                                // _buildWelcomeSection(dashData),
                                Flex(
                                  direction: Axis.horizontal,
                                  spacing: 20,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: _buildStatsCards(dashData),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: _buildRecentProgress(),
                                    ),
                                  ],
                                ),
                                _buildActivitiesSection(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TogglesProvider togglesProvider,
      Map<dynamic, dynamic> dashData, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
              onChanged: (value) {
                togglesProvider.searchAction(
                  _searchController.text,
                  dashData['notifications']['read'],
                  'title',
                );
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppUtils.mainWhite(context).withOpacity(0.1),
                prefixIcon: Icon(
                  FluentIcons.search_24_regular,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search activities...",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.alert_24_regular,
                      size: 24,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                  if (isNewActivities)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppUtils.mainRed(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
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
            ],
          ),
        ],
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
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: DesktopCardRow(
        users: dashData['user_count'] ?? 0,
        materialCount: dashData['material_count'] ?? {},
      ),
    );
  }

  Widget _buildRecentProgress() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FluentIcons.chart_multiple_24_regular,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              Gap(12),
              Text(
                'Recent Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: RecentProgress(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    'Activities',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Track your recent notifications and history',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Optional: Add a filter or action button
              IconButton(
                onPressed: () {
                  // Add filter or refresh functionality
                },
                icon: Icon(
                  FluentIcons.filter_24_regular,
                  color: AppUtils.mainBlue(context),
                ),
                tooltip: 'Filter',
              ),
            ],
          ),

          // Custom Tab Header
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppUtils.mainGrey(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    label: 'Recent Activities',
                    icon: FluentIcons.clock_24_regular,
                    isSelected: _tabController.index == 0,
                    onTap: () {
                      _tabController.animateTo(0);
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildTabButton(
                    label: 'Activity History',
                    icon: FluentIcons.history_24_regular,
                    isSelected: _tabController.index == 1,
                    onTap: () {
                      _tabController.animateTo(1);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.325,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(DesktopActivities()),
                _buildTabContent(ActivityHistory()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppUtils.mainWhite(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppUtils.mainBlue(context) : Colors.grey[600],
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color:
                    isSelected ? AppUtils.mainBlue(context) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
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
