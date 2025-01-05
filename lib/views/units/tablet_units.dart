import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/units_widgets/tablet_semester_holder.dart';

class TabletUnits extends StatelessWidget {
  TabletUnits({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  FluentIcons.class_24_regular,
                  color: AppUtils.$mainBlue,
                ),
                Text(
                  "Units",
                  style: TextStyle(
                    fontSize: 30,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                      backgroundColor:
                          WidgetStatePropertyAll(AppUtils.$mainBlue),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("Add units",
                          style: TextStyle(
                              fontSize: 16, color: AppUtils.$mainWhite)),
                      Gap(5),
                      Icon(FluentIcons.class_24_regular,
                          size: 16, color: AppUtils.$mainWhite),
                    ],
                  ),
                )
              ],
            ),
            const Gap(10),
            const Divider(
              color: Color(0xFFCECECE),
            ),
            const Gap(20),
            // Make the scrollable content expand dynamically
            Expanded(
              child: SingleChildScrollView(
                // clipBehavior: Clip.none,
                child: Column(
                  children: const [
                    TabletSemesterHolder(),
                    Gap(20),
                    TabletSemesterHolder(),
                    Gap(20),
                    TabletSemesterHolder(),
                    Gap(20),
                    TabletSemesterHolder(),
                    Gap(20),
                    TabletSemesterHolder(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
