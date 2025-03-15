import 'package:flutter/material.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/widgets/dashboard_widgets/recent_activities/activity.dart';
import 'package:provider/provider.dart';

class DesktopActivities extends StatelessWidget {
  const DesktopActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (BuildContext context, DashboardProvider dashboardProvider, _) {
        Map activities = dashboardProvider.dashData['notifications'] ?? {};

        List unreadActivities =
            activities.isNotEmpty && activities['unread'].isNotEmpty
                ? List.from(activities['unread'] as List)
                : [];

        unreadActivities.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']) ?? 0;
        });

        return unreadActivities.isEmpty
            ? EmptyWidget(
                errorHeading: "No recent activities",
                errorDescription: "There are no new activities today",
                image: 'assets/images/empty_act.png',
              )
            : SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          children: unreadActivities.map((activity) {
                        return Activity(activity: activity);
                      }).toList())
                    ],
                  ),
                ),
              );
      },
    );
  }
}
