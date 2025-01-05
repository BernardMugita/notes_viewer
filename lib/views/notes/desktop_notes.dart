import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_empty_overview.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_notes_item.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_notes_overview.dart';

class DesktopNotes extends StatelessWidget {
  const DesktopNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: const SideNavigation(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        FluentIcons.book_24_regular,
                        color: AppUtils.$mainBlue,
                      ),
                      const Gap(5),
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
                          padding:
                              WidgetStatePropertyAll(const EdgeInsets.all(20)),
                          backgroundColor:
                              WidgetStatePropertyAll(AppUtils.$mainBlue),
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
                    // This ensures the scrolling area takes the remaining height
                    child: SizedBox(
                      width: double.infinity,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  16,
                                  (_) => const Padding(
                                    padding: EdgeInsets.only(bottom: 0),
                                    child: DesktopNotesItem(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: 1,
                            height: MediaQuery.of(context).size.height / 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppUtils.$mainGrey,
                              ),
                            ),
                          ),
                          const Gap(20),
                          Expanded(
                            flex: 1,
                            child: const Column(
                              children: [
                                DesktopNotesOverview(),
                                Gap(20),
                                DesktopEmptyOverview()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
