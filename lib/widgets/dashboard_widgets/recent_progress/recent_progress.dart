import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/recently_viewed/recently_viewed.dart';
import 'package:provider/provider.dart';

class RecentProgress extends StatelessWidget {
  const RecentProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (BuildContext context, dashboardProvider, _) {
      final currentlyViewing = dashboardProvider.currentlyViewing;

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
            if (currentlyViewing.isNotEmpty)
              RecentlyViewed()
            else
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    // height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppUtils.mainWhite(context),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppUtils.mainGrey(context)),
                    ),
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.prohibited_24_regular,
                          color: AppUtils.mainRed(context),
                          size: 40,
                        ),
                        Text("No recently viewed books",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppUtils.mainGrey(context))),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
}
