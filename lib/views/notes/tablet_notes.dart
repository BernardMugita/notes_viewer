import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/notes_widgets/tablet_notes_item.dart';

class TabletNotes extends StatelessWidget {
  TabletNotes({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 30,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(const EdgeInsets.all(20)),
                    backgroundColor: WidgetStatePropertyAll(AppUtils.$mainBlue),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "Upload Notes",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppUtils.$mainWhite,
                        ),
                      ),
                      const Gap(5),
                      Icon(
                        FluentIcons.book_add_24_regular,
                        size: 16,
                        color: AppUtils.$mainWhite,
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
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    16,
                    (_) => const Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: TabletNotesItem(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
