import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity.dart';
import 'package:provider/provider.dart';

class ActivityHistory extends StatelessWidget {
  const ActivityHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: _buildActivityItem(0.4),
        tabletLayout: _buildActivityItem(0.4),
        desktopLayout: _buildActivityItem(0.7));
  }

  Widget _buildActivityItem(double heightDenomenator) {
    return Consumer<DashboardProvider>(
      builder: (BuildContext context, dashboardProvider, _) {
        Map activities = dashboardProvider.dashData['notifications'] ?? {};

        List readActivities =
            activities.isNotEmpty && activities['read'].isNotEmpty
                ? List.from(activities['read'] as List)
                : [];

        readActivities.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']);
        });

        if (readActivities.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(
                    FluentIcons.mail_inbox_add_24_regular,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                  Text(
                    'No recent activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'You\'re all caught up! Check back later for updates',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            spacing: 12,
            children: readActivities.map((activity) {
              return Activity(activity: activity);
            }).toList(),
          ),
        );
      },
    );
  }
}
