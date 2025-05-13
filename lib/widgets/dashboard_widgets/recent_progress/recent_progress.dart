import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/recently_viewed/recently_viewed.dart';

class RecentProgress extends StatelessWidget {
  const RecentProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppUtils.mainGrey(context)),
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              Icon(FluentIcons.fast_forward_24_regular,
                  color: AppUtils.mainBlue(context)),
              Text("Continue where you left off",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppUtils.mainBlue(context),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Divider(
            color: AppUtils.mainGrey(context),
          ),
          RecentlyViewed()
        ],
      ),
    );
  }
}
