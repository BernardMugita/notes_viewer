import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class TabletSettings extends StatefulWidget {
  const TabletSettings({super.key});

  @override
  State<TabletSettings> createState() => _TabletSettingsState();
}

class _TabletSettingsState extends State<TabletSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(FluentIcons.re_order_24_regular),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        color: AppUtils.$mainWhite,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Settings",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: AppUtils.$mainBlue,
                                    fontWeight: FontWeight.bold)),
                            Gap(30),
                            _buildSettingsDetails(context,
                                title: 'Appearance',
                                value: 'Light Mode / Dark Mode'),
                            Spacer(),
                            Divider(),
                            Gap(5),
                            Text(
                              "Acknowledgment",
                              style: TextStyle(color: AppUtils.$mainBlue),
                            ),
                            Gap(5),
                            Text(
                              "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                              style: TextStyle(color: AppUtils.$mainGrey),
                            ),
                            Text("Powered by Labs")
                          ]),
                    ),
                    Gap(40),
                    PlatformDetails(),
                  ],
                )
              ])),
        ));
  }

  Widget _buildSettingsDetails(BuildContext context,
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
