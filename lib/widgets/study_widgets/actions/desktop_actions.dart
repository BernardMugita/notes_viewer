import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/widgets/study_widgets/actions/desktop_filter_drop_down.dart';
import 'package:note_viewer/widgets/study_widgets/actions/desktop_group_drop_down.dart';
import 'package:note_viewer/widgets/study_widgets/actions/desktop_sort_drop_down.dart';
import 'package:provider/provider.dart';

class DesktopActions extends StatelessWidget {
  const DesktopActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<TogglesProvider>().toggleGroupDropDown();
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text("Group"),
                            const Gap(5),
                            Icon(FluentIcons.tab_group_24_regular),
                          ],
                        ),
                      ),
                      if (context.watch<TogglesProvider>().showGroupDropDown)
                        Positioned(
                          top: 40,
                          child: DesktopGroupDropDown(),
                        ),
                    ],
                  ),
                  const Gap(10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<TogglesProvider>()
                              .toggleFilterDropDown();
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text("Filter"),
                            const Gap(5),
                            Icon(FluentIcons.filter_24_regular),
                          ],
                        ),
                      ),
                      if (context.watch<TogglesProvider>().showFilterDropDown)
                        Positioned(
                          top: 40,
                          child: DesktopFilterDropDown(),
                        ),
                    ],
                  ),
                  const Gap(10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<TogglesProvider>().toggleSortDropDown();
                        },
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text("Sort"),
                            const Gap(5),
                            Icon(FluentIcons.arrow_sort_24_regular),
                          ],
                        ),
                      ),
                      if (context.watch<TogglesProvider>().showSortDropDown)
                        Positioned(
                          top: 40,
                          child: DesktopSortDropDown(),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
