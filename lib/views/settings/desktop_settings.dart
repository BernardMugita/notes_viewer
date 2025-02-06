import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
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
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Row(
                      children: [
                        const Icon(
                          FluentIcons.settings_24_regular,
                          color: AppUtils.$mainBlue,
                        ),
                        const Gap(5),
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 30,
                            color: AppUtils.$mainBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    const Divider(
                      color: Color(0xFFCECECE),
                    ),
                    const Gap(20),
                    Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundColor: AppUtils.$mainWhite,
                                child: Icon(
                                  FluentIcons.settings_24_regular,
                                  size: 100,
                                  color: AppUtils.$mainBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(40),
                        Expanded(
                            flex: 2,
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
                                  color: AppUtils.$mainWhite,
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Settings",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppUtils.$mainBlue,
                                              fontWeight: FontWeight.bold)),
                                      Gap(30),
                                      _buildAccountDetails(context,
                                          title: 'Appearance',
                                          value: 'Light Mode / Dark Mode'),
                                      Spacer(),
                                      Divider(),
                                      Gap(5),
                                      Text(
                                        "Acknowledgment",
                                        style: TextStyle(
                                            color: AppUtils.$mainBlue),
                                      ),
                                      Gap(5),
                                      Text(
                                        "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                        style: TextStyle(
                                            color: AppUtils.$mainGrey),
                                      ),
                                      Text("Powered by Labs")
                                    ]),
                              );
                            })),
                        Expanded(flex: 2, child: SizedBox())
                      ],
                    )
                  ])))
        ]));
  }

  Widget _buildAccountDetails(BuildContext context,
      {required String title, required String value}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppUtils.$mainGrey)),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.dark_theme_24_regular,
                      color: AppUtils.$mainBlue,
                    ))
              ],
            )),
        Positioned(
            top: -10,
            left: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: AppUtils.$mainWhite,
              child: context.watch<UserProvider>().isLoading
                  ? SizedBox(
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    )
                  : Text(
                      title,
                      style: TextStyle(color: AppUtils.$mainGrey, fontSize: 12),
                    ),
            ))
      ],
    );
  }
}
