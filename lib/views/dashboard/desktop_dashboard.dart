import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/desktop_card_row.dart';
import 'package:note_viewer/widgets/dashboard_widgets/recent_activities/desktop_activities.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopDashboard extends StatelessWidget {
  const DesktopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // print(context.read<AuthProvider>().user);

    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: SideNavigation(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello, Jerome",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppUtils.$mainBlue)),
                          Text(
                              "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<TogglesProvider>().toggleSearchBar();
                            },
                            style: ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.all(20)),
                                backgroundColor: WidgetStatePropertyAll(
                                    const Color(0xFFF1F1F1)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Icon(
                              FluentIcons.search_24_regular,
                              color: AppUtils.$mainBlue,
                            ),
                          ),
                          Gap(10),
                          if (context.watch<TogglesProvider>().showSearchBar)
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Search",
                                  hintStyle: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          Gap(10),
                          ElevatedButton(
                            style: ButtonStyle(
                                padding:
                                    WidgetStatePropertyAll(EdgeInsets.all(20)),
                                backgroundColor:
                                    WidgetStatePropertyAll(AppUtils.$mainBlue),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text("Upload notes",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.$mainWhite)),
                                Gap(5),
                                Icon(FluentIcons.book_add_24_regular,
                                    size: 16, color: AppUtils.$mainWhite),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Gap(10),
                  Divider(
                    color: const Color(0xFFCECECE),
                  ),
                  Gap(20),
                  DesktopCardRow(),
                  Gap(20),
                  DesktopActivities()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
