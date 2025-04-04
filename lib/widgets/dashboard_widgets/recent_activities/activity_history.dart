import 'package:flutter/material.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
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
        desktopLayout: _buildActivityItem(0.4));
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

        return readActivities.isEmpty
            ? EmptyWidget(
                errorHeading: "No Activities Loaded",
                errorDescription: "Activity history may be empty",
                image: 'assets/images/empty_act.png',
              )
            : SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * heightDenomenator,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: readActivities.map((activity) {
                          return Activity(activity: activity);
                        }).toList(),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
