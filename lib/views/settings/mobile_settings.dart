import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/theme_provider.dart';
// import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/confirm_exit.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class MobileSettings extends StatefulWidget {
  const MobileSettings({super.key});

  @override
  State<MobileSettings> createState() => _MobileSettingsState();
}

class _MobileSettingsState extends State<MobileSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmExit(),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppUtils.backgroundPanel(context),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppUtils.mainBlue(context),
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              FluentIcons.re_order_24_regular,
              color: AppUtils.mainWhite(context),
            ),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(spacing: 10, children: [
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
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 24,
                            color: AppUtils.mainBlue(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(30),
                        _buildSettings(
                          context,
                          title: 'Appearance',
                          value: 'Light Mode / Dark Mode',
                          onpressed: themeProvider.toggleTheme,
                        ),
                        const Spacer(),
                        const Divider(),
                        const Gap(5),
                        Text(
                          "Acknowledgment",
                          style: TextStyle(color: AppUtils.mainBlue(context)),
                        ),
                        const Gap(5),
                        Text(
                          "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                          style: TextStyle(color: AppUtils.mainGrey(context)),
                        ),
                        const Text("Powered by Labs")
                      ],
                    ),
                  ),
                  const Gap(40),
                  PlatformDetails(),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context,
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
