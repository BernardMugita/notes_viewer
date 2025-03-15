import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppUtils.mainWhite(context))),
                  Text(
                      "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(
                          fontSize: 16, color: AppUtils.mainWhite(context))),
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
                        size: 35,
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
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.settings_24_regular,
                        size: 30,
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
