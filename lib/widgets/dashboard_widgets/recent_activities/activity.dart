import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    final material = 'recordings';
    return Consumer<TogglesProvider>(
        builder: (BuildContext context, toggleProvider, _) {
      return GestureDetector(
        onTap: () {
          toggleProvider.toggleIsActivityExpanded();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: AppUtils.$mainWhite,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bio-Chemistry notes uploaded",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (toggleProvider.isActivityExpanded)
                    Icon(FluentIcons.chevron_up_24_filled)
                  else
                    Icon(FluentIcons.chevron_down_24_filled)
                ],
              ),
              if (toggleProvider.isActivityExpanded)
                Column(
                  children: [
                    Divider(
                      color: AppUtils.$mainBlueAccent,
                      indent: 10,
                    ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      title: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: material == 'notes'
                                      ? Colors.purpleAccent.withOpacity(0.2)
                                      : material == 'slides'
                                          ? Colors.amber.withOpacity(0.2)
                                          : material == 'recordings'
                                              ? AppUtils.$mainBlue
                                                  .withOpacity(0.2)
                                              : material ==
                                                      "student_contributions"
                                                  ? Colors.deepOrange
                                                      .withOpacity(0.2)
                                                  : AppUtils.$mainGreen
                                                      .withOpacity(0.2),
                                  child: Icon(
                                    material == 'notes'
                                        ? FluentIcons.book_24_regular
                                        : material == 'slides'
                                            ? FluentIcons
                                                .slide_content_24_regular
                                            : material == 'recordings'
                                                ? FluentIcons.video_24_regular
                                                : material ==
                                                        "student_contributions"
                                                    ? FluentIcons
                                                        .people_20_regular
                                                    : FluentIcons
                                                        .person_24_regular,
                                    color: material == 'notes'
                                        ? Colors.purpleAccent
                                        : material == 'slides'
                                            ? Colors.amber
                                            : material == 'recordings'
                                                ? AppUtils.$mainBlue
                                                : material ==
                                                        "student_contributions"
                                                    ? Colors.deepOrange
                                                    : AppUtils.$mainGreen,
                                  )),
                              Gap(10),
                              if (material == 'notes')
                                Text("Human Eye Notes uploaded at 12:00"),
                              if (material == 'slides')
                                Text("Human Eye Slide uploaded at 12:00"),
                              if (material == 'recordings')
                                Text("Human Eye Recording uploaded at 12:00"),
                              if (material == "student_contributions")
                                Text(
                                    "New Student Contribution uploaded at 12:00"),
                              if (material == "user")
                                Text("Username created a new account at 12:00"),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
