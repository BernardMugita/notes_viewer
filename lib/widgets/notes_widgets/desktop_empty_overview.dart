import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

class DesktopEmptyOverview extends StatelessWidget {
  const DesktopEmptyOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Icon(
            FluentIcons.prohibited_24_regular,
            size: 64,
            color: Colors.red,
          ),
          Gap(10),
          Text("Notes not selected",
              style: TextStyle(fontSize: 20, color: AppUtils.mainBlue(context))),
          Gap(5),
          Text("Select a notes item from the list to view it",
              style: TextStyle(fontSize: 16, color: AppUtils.mainBlack(context))),
        ],
      ),
    );
  }
}
