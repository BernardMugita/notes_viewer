import 'package:flutter/material.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/activity.dart';

class ActivityHistory extends StatelessWidget {
  const ActivityHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          ]),
        ));
  }
}
