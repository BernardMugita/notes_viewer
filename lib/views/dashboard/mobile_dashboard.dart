import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/mobile_card_row.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class MobileDashboard extends StatelessWidget {
  MobileDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print(context.read<AuthProvider>().user);

    return Scaffold(
      key: _scaffoldKey, // Attach the global key to the Scaffold
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(FluentIcons.re_order_24_regular),
        ),
      ),
      drawer: const ResponsiveNav(),
      body: Consumer<DashboardProvider>(
          builder: (BuildContext context, dashBoardProvider, _) {
        final dashData = dashBoardProvider.dashData;

        return dashBoardProvider.isLoading
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: LoadingAnimationWidget.newtonCradle(
                  color: AppUtils.$mainBlue,
                  size: 100,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Hello, ${dashData.isNotEmpty ? dashData['user']['username'] : 'Username'}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppUtils.$mainBlue)),
                            Text(
                                "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const Gap(10),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      const EdgeInsets.all(20)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppUtils.$mainBlue),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Icon(
                                    FluentIcons.book_add_24_regular,
                                    size: 16,
                                    color: AppUtils.$mainWhite),
                              ),
                              const Gap(10),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<TogglesProvider>()
                                      .toggleSearchBar();
                                },
                                style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      const EdgeInsets.all(20)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      const Color(0xFFF1F1F1)),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  FluentIcons.search_24_regular,
                                  color: AppUtils.$mainBlue,
                                ),
                              ),
                              const Gap(10),
                              if (context
                                  .watch<TogglesProvider>()
                                  .showSearchBar)
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Search",
                                      hintStyle: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    const Divider(
                      color: Color(0xFFCECECE),
                    ),
                    const Gap(20),
                    MobileCardRow(
                      user: dashData['user'] ?? {},
                      users: dashData['user_count'] ?? 0,
                      materialCount: dashData['material_count'] ?? {},
                    ),
                    const Gap(20),
                    const DesktopActivities(),
                  ],
                ),
              );
      }),
    );
  }
}
