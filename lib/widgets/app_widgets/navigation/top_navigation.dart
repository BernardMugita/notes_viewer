import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class TopNavigation extends StatefulWidget {
  final bool isRecentActivities;

  const TopNavigation({super.key, required this.isRecentActivities});

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: AppUtils.mainBlue(context), borderRadius: BorderRadius.circular(5)),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            child: Icon(FluentIcons.person_24_regular),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.watch<UserProvider>().isLoading)
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    minHeight: 1,
                    color: AppUtils.mainWhite(context),
                  ),
                )
              else
                Text(user.isNotEmpty ? user['username'] : 'Guest',
                    style: TextStyle(
                        fontSize: 16,
                        color: AppUtils.mainWhite(context),
                        fontWeight: FontWeight.bold)),
              if (context.watch<UserProvider>().isLoading)
                SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    minHeight: 1,
                    color: AppUtils.mainWhite(context),
                  ),
                )
              else
                SizedBox(
                  width: 150,
                  child: Text(
                      user.isNotEmpty ? user['email'] : 'guest@email.com',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          color: AppUtils.mainWhite(context))),
                ),
            ],
          ),
          Gap(10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                FluentIcons.alert_24_regular,
                size: 25,
                color: AppUtils.mainWhite(context),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: widget.isRecentActivities
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
                size: 25,
                color: AppUtils.mainWhite(context),
              ))
        ],
      ),
    );
  }
}
