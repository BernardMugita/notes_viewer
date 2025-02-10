import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopBanner extends StatefulWidget {
  final Map data;

  const DesktopBanner({super.key, required this.data});

  @override
  State<DesktopBanner> createState() => _DesktopBannerState();
}

class _DesktopBannerState extends State<DesktopBanner> {
  @override
  Widget build(BuildContext context) {
    final dashData = widget.data;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppUtils.$mainBlue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Maktaba!",
            style: TextStyle(color: AppUtils.$mainWhite),
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
                          color: AppUtils.$mainWhite)),
                  Text(
                      "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style:
                          TextStyle(fontSize: 16, color: AppUtils.$mainWhite)),
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
                        color: AppUtils.$mainWhite,
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: AppUtils.$mainRed,
                          ))
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.settings_24_regular,
                        size: 30,
                        color: AppUtils.$mainWhite,
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
