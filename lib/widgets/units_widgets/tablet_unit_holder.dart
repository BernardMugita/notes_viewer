import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletUnitHolder extends StatefulWidget {
  final Map unit;

  const TabletUnitHolder({super.key, required this.unit});

  @override
  State<TabletUnitHolder> createState() => _TabletUnitHolderState();
}

class _TabletUnitHolderState extends State<TabletUnitHolder> {
  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;

    return GestureDetector(
      onTap: () {
        context.go('/units/notes');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Icon(
              FluentIcons.doctor_24_regular,
              size: 45,
            ),
            Text(unit['name'],
                style: TextStyle(
                    fontSize: 24,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold)),
            Gap(5),
            Divider(
              color: AppUtils.$mainGrey,
            ),
            Gap(5),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.book_24_regular),
                    Gap(5),
                    Expanded(
                        child: Text("Notes",
                            style: TextStyle(
                                fontSize: 18, color: AppUtils.$mainBlue))),
                    Text("2")
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.slide_content_24_regular),
                    Gap(5),
                    Expanded(
                        child: Text("Slides",
                            style: TextStyle(
                                fontSize: 18, color: AppUtils.$mainBlue))),
                    Text("4")
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.video_24_regular),
                    Gap(5),
                    Expanded(
                        child: Text("Recordings",
                            style: TextStyle(
                                fontSize: 18, color: AppUtils.$mainBlue))),
                    Text("1")
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.person_32_regular),
                    Gap(5),
                    Expanded(
                        child: Text("Student Contributions",
                            style: TextStyle(
                                fontSize: 18, color: AppUtils.$mainBlue))),
                    Text("1")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
