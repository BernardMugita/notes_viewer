import 'package:flutter/material.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity.dart';
import 'package:provider/provider.dart';

class ActivityHistory extends StatelessWidget {
  const ActivityHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (BuildContext context, dashboardProvider, _) {
        Map activities = dashboardProvider.dashData['notifications'] ?? {};

        List readActivities = List.from(activities['read'] as List);

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
                height: MediaQuery.of(context).size.height * 0.35,
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
