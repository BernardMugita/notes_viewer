import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/theme_provider.dart';
// import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppUtils.backgroundPanel(context),
        appBar: AppBar(
          backgroundColor: AppUtils.mainBlue(context),
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
                  spacing: 10,
                  children: [
                    // if (!context.watch<TogglesProvider>().isBannerDismissed)
                    //   Consumer<TogglesProvider>(
                    //         builder: (context, toggleProvider, _) {
                    //       return toggleProvider.isBannerDismissed
                    //           ? SizedBox()
                    //           : MembershipBanner();
                    //     }),
                    Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 24,
                        color: AppUtils.mainBlue(context),
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
                            color: AppUtils.mainWhite(context),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Settings",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppUtils.mainBlue(context),
                                        fontWeight: FontWeight.bold)),
                                Gap(30),
                                _buildSettingsDetails(context,
                                    title: 'Appearance',
                                    value: 'Light Mode / Dark Mode',
                                    onpressed: themeProvider.toggleTheme),
                                Spacer(),
                                Divider(),
                                Gap(5),
                                Text(
                                  "Acknowledgment",
                                  style: TextStyle(
                                      color: AppUtils.mainBlue(context)),
                                ),
                                Gap(5),
                                Text(
                                  "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                  style: TextStyle(
                                      color: AppUtils.mainGrey(context)),
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
