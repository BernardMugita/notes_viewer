import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/theme_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:note_viewer/widgets/app_widgets/navigation/top_navigation.dart';
import 'package:note_viewer/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:note_viewer/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopSettings extends StatefulWidget {
  const DesktopSettings({super.key});

  @override
  State<DesktopSettings> createState() => _DesktopSettingsState();
}

class _DesktopSettingsState extends State<DesktopSettings> {
  @override
  Widget build(BuildContext context) {
    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
        body: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.horizontal,
            children: [
          isMinimized
              ? Expanded(
                  flex: 1,
                  child: SideNavigation(),
                )
              : SizedBox(
                  width: 80,
                  child: SideNavigation(),
                ),
          Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: 20,
                      bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(spacing: 10, children: [
                      if (!context
                              .watch<TogglesProvider>()
                              .isBannerDismissed)
                            Consumer<TogglesProvider>(
                            builder: (context, toggleProvider, _) {
                          return toggleProvider.isBannerDismissed
                              ? SizedBox()
                              : MembershipBanner();
                        }),
                      Row(
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 24,
                              color: AppUtils.mainBlue(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          TopNavigation(
                              isRecentActivities: context
                                  .watch<DashboardProvider>()
                                  .isNewActivities)
                        ],
                      ),
                      const Gap(20),
                      Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                              flex: 3,
                              child: Consumer<TogglesProvider>(builder: (
                                context,
                                toggleProvider,
                                child,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.85,
                                  decoration: BoxDecoration(
                                    color: AppUtils.mainWhite(context),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Toggle Settings",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    AppUtils.mainBlue(context),
                                                fontWeight: FontWeight.bold)),
                                        Gap(30),
                                        _buildSettingsDetails(context,
                                            title: 'Appearance',
                                            value: 'Light Mode / Dark Mode',
                                            onpressed:
                                                themeProvider.toggleTheme),
                                        Spacer(),
                                        Divider(),
                                        Gap(5),
                                        Text(
                                          "Acknowledgment",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainBlue(context)),
                                        ),
                                        Gap(5),
                                        Text(
                                          "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainGrey(context)),
                                        ),
                                        Text("Powered by Labs")
                                      ]),
                                );
                              })),
                          Expanded(flex: 4, child: SizedBox()),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [PlatformDetails()],
                                ),
                              ))
                        ],
                      )
                    ]),
                  )))
        ]));
  }

  Widget _buildSettingsDetails(BuildContext context,
      {required String title,
      required String value,
      required VoidCallback onpressed}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppUtils.mainGrey(context))),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                IconButton(
                    onPressed: () {
                      onpressed();
                    },
                    icon: Icon(
                      FluentIcons.dark_theme_24_regular,
                      color: AppUtils.mainBlue(context),
                    ))
              ],
            )),
        Positioned(
            top: -10,
            left: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: AppUtils.mainWhite(context),
              child: context.watch<UserProvider>().isLoading
                  ? SizedBox(
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    )
                  : Text(
                      title,
                      style: TextStyle(
                          color: AppUtils.mainGrey(context), fontSize: 12),
                    ),
            ))
      ],
    );
  }
}
