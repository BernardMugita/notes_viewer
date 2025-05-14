import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
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
    final user = context.watch<UserProvider>().user;

    return Scaffold(
        backgroundColor: AppUtils.backgroundPanel(context),
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
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1,
                          top: 20,
                          bottom: 20),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          // if (!context
                          //           .watch<TogglesProvider>()
                          //           .isBannerDismissed)
                          //         Consumer<TogglesProvider>(
                          //         builder: (context, toggleProvider, _) {
                          //       return toggleProvider.isBannerDismissed
                          //           ? SizedBox()
                          //           : MembershipBanner();
                          //     }),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppUtils.mainBlue(context),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppUtils.mainWhite(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
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
                                              backgroundColor: context
                                                      .watch<
                                                          DashboardProvider>()
                                                      .isNewActivities
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
                                        )),
                                    Gap(10),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: AppUtils.mainGrey(context),
                                      ),
                                    ),
                                    Gap(10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (context
                                            .watch<UserProvider>()
                                            .isLoading)
                                          SizedBox(
                                            width: 150,
                                            child: LinearProgressIndicator(
                                              minHeight: 1,
                                              color:
                                                  AppUtils.mainWhite(context),
                                            ),
                                          )
                                        else
                                          Text(
                                              user.isNotEmpty
                                                  ? user['username']
                                                  : 'Guest',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppUtils.mainWhite(
                                                      context),
                                                  fontWeight: FontWeight.bold)),
                                        if (context
                                            .watch<UserProvider>()
                                            .isLoading)
                                          SizedBox(
                                            width: 50,
                                            child: LinearProgressIndicator(
                                              minHeight: 1,
                                              color:
                                                  AppUtils.mainWhite(context),
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                                user.isNotEmpty
                                                    ? user['email']
                                                    : 'guest@email.com',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 12,
                                                    color: AppUtils.mainWhite(
                                                        context))),
                                          ),
                                      ],
                                    ),
                                    Gap(10),
                                    CircleAvatar(
                                      child:
                                          Icon(FluentIcons.person_24_regular),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      decoration: BoxDecoration(
                                          color: AppUtils.mainWhite(context),
                                          border: Border.all(
                                              color:
                                                  AppUtils.mainGrey(context)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Toggle Settings",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppUtils.mainBlue(
                                                        context),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Gap(30),
                                            _buildSettingsDetails(context,
                                                title: 'Appearance',
                                                value: 'Light Mode / Dark Mode',
                                                onpressed:
                                                    themeProvider.toggleTheme),
                                            Spacer(),
                                            Divider(
                                              color: AppUtils.mainGrey(context),
                                            ),
                                            Gap(5),
                                            Text(
                                              "Acknowledgment",
                                              style: TextStyle(
                                                  color: AppUtils.mainBlue(
                                                      context)),
                                            ),
                                            Gap(5),
                                            Text(
                                              "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                              style: TextStyle(
                                                  color: AppUtils.mainGrey(
                                                      context)),
                                            ),
                                            Text("Powered by Labs")
                                          ]),
                                    );
                                  })),
                              Expanded(flex: 4, child: SizedBox()),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
