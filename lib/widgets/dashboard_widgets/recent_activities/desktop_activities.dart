import 'package:flutter/material.dart';
import 'package:note_viewer/providers/activity_provider.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity.dart';
import 'package:provider/provider.dart';

class DesktopActivities extends StatelessWidget {
  const DesktopActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityProvider>(
        builder: (BuildContext context, actiivityProvider, _) {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (actiivityProvider.activities.isNotEmpty)
              Column(
                children: [
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                  Activity(),
                ],
              )
            else
              EmptyWidget(
                  errorHeading: "No recent activities",
                  errorDescription: "There are no new activities today",
                  image: 'assets/images/empty_act.png'),
          ]),
        ),
      );
    });
  }
}
