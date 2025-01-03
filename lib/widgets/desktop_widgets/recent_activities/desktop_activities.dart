import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/desktop_widgets/recent_activities/activity.dart';

class DesktopActivities extends StatelessWidget {
  const DesktopActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Recent Activities",
          style: TextStyle(fontSize: 16, color: AppUtils.$mainGrey)),
      Gap(10),
      Column(
        children: [
          Activity(),
          Activity(),
          Activity(),
          Activity(),
          Activity(),
        ],
      )
    ]));
  }
}
