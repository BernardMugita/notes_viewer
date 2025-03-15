import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class MembershipBanner extends StatefulWidget {
  const MembershipBanner({super.key});

  @override
  State<MembershipBanner> createState() => _MembershipBannerState();
}

class _MembershipBannerState extends State<MembershipBanner> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppUtils.mainGreen(context).withOpacity(0.5)),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.yellowAccent,
                radius: 10,
                child: Icon(FluentIcons.info_24_regular),
              ),
              Gap(10),
              Text(
                  "This product is in Beta Testing, you are using the free version.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppUtils.mainBlack(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
              // const Spacer(),
              Consumer<TogglesProvider>(builder: (context, toggleProvider, _) {
                return ElevatedButton(
                  onPressed: () {
                    toggleProvider.dismissMembershipBanner();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dismiss'),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppUtils.mainGrey(context),
                        child: Icon(
                          FluentIcons.dismiss_24_regular,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ),
        tabletLayout: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppUtils.mainGreen(context).withOpacity(0.5)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.yellowAccent,
                radius: 10,
                child: Icon(FluentIcons.info_24_regular),
              ),
              Gap(10),
              Text(
                  "This product is in Beta Testing, you are using the free version.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppUtils.mainBlack(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const Spacer(),
              Consumer<TogglesProvider>(builder: (context, toggleProvider, _) {
                return ElevatedButton(
                  onPressed: () {
                    toggleProvider.dismissMembershipBanner();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text('Dismiss'),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppUtils.mainGrey(context),
                        child: Icon(
                          FluentIcons.dismiss_24_regular,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ),
        desktopLayout: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppUtils.mainGreen(context).withOpacity(0.5)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.yellowAccent,
                radius: 20,
                child: Icon(
                  FluentIcons.info_24_regular,
                  color: AppUtils.mainBlack(context),
                ),
              ),
              Gap(10),
              Text(
                  "This product is in Beta Testing, you are using the free version.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppUtils.mainBlack(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
              const Spacer(),
              Consumer<TogglesProvider>(builder: (context, toggleProvider, _) {
                return ElevatedButton(
                  onPressed: () {
                    toggleProvider.dismissMembershipBanner();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: Row(
                    spacing: 10,
                    children: [
                      Text('Dismiss'),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppUtils.mainGrey(context),
                        child: Icon(
                          FluentIcons.dismiss_24_regular,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ));
  }
}
