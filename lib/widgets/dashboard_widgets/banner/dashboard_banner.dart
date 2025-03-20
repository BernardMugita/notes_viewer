import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';

class DashboardBanner extends StatefulWidget {
  final Map data;

  const DashboardBanner({super.key, required this.data});

  @override
  State<DashboardBanner> createState() => _DashboardBannerState();
}

class _DashboardBannerState extends State<DashboardBanner> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: _buildDashboardBanner(18, 16, 25, 25),
        tabletLayout: _buildDashboardBanner(18, 16, 25, 25),
        desktopLayout: _buildDashboardBanner(18, 16, 25, 25));
  }

  Widget _buildDashboardBanner(double fontSizeUsername, double fontSizeDate,
      double iconSizeAlert, double iconSizeSettings) {
    final dashData = widget.data;

    bool isNewActivities =
        dashData.isNotEmpty && dashData['notifications'].isNotEmpty
            ? dashData['notifications']!['unread']!.isNotEmpty
            : false;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppUtils.mainBlue(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Maktaba!",
            style: TextStyle(color: AppUtils.mainWhite(context)),
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Hello, ${dashData.isNotEmpty ? dashData['user']['username'] : 'Username'}",
                      style: TextStyle(
                          fontSize: fontSizeUsername,
                          fontWeight: FontWeight.bold,
                          color: AppUtils.mainWhite(context))),
                  Text(
                      "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                          fontSize: fontSizeDate,
                          color: AppUtils.mainWhite(context))),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        FluentIcons.alert_24_regular,
                        size: iconSizeAlert,
                        color: AppUtils.mainWhite(context),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: isNewActivities
                                ? AppUtils.mainRed(context)
                                : AppUtils.mainGrey(context),
                          ))
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        context.go('/settings');
                      },
                      icon: Icon(
                        FluentIcons.settings_24_regular,
                        size: iconSizeSettings,
                        color: AppUtils.mainWhite(context),
                      ))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
