import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class RecentlyViewed extends StatefulWidget {
  const RecentlyViewed({super.key});

  @override
  State<RecentlyViewed> createState() => _RecentlyViewedState();
}

class _RecentlyViewedState extends State<RecentlyViewed> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, TogglesProvider>(
      builder: (BuildContext context, dashboardProvider, toggleProvider, _) {
        final currentlyViewing = dashboardProvider.currentlyViewing;
        final uploadType = currentlyViewing['type'];

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppUtils.mainGrey(context)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            spacing: 20,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: AppUtils.mainGrey(context)),
                    borderRadius: BorderRadius.circular(200)),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: uploadType == 'notes'
                      ? Colors.purpleAccent.withOpacity(0.2)
                      : uploadType == 'slides'
                          ? Colors.amber.withOpacity(0.2)
                          : uploadType == 'recordings' ||
                                  uploadType == 'recording'
                              ? AppUtils.mainBlue(context).withOpacity(0.2)
                              : uploadType == "student_contributions"
                                  ? Colors.deepOrange.withOpacity(0.2)
                                  : AppUtils.mainGreen(context)
                                      .withOpacity(0.2),
                  child: Icon(
                    uploadType == 'notes'
                        ? FluentIcons.book_24_regular
                        : uploadType == 'slides'
                            ? FluentIcons.slide_content_24_regular
                            : uploadType == 'recordings' ||
                                    uploadType == 'recording'
                                ? FluentIcons.video_24_regular
                                : uploadType == "student_contributions"
                                    ? FluentIcons.people_20_regular
                                    : FluentIcons.person_24_regular,
                    color: uploadType == 'notes'
                        ? Colors.purpleAccent
                        : uploadType == 'slides'
                            ? Colors.amber
                            : uploadType == 'recordings' ||
                                    uploadType == 'recording'
                                ? AppUtils.mainBlue(context)
                                : uploadType == "student_contributions"
                                    ? Colors.deepOrange
                                    : AppUtils.mainGreen(context),
                    size: 80,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.185,
                child: VerticalDivider(
                  color: AppUtils.mainGrey(context),
                  thickness: 1,
                  width: 10,
                ),
              ),
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentlyViewing['name'],
                    style: TextStyle(
                        color: AppUtils.mainBlue(context),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: toggleProvider.isSideNavMinimized
                        ? MediaQuery.of(context).size.width * 0.225
                        : MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      currentlyViewing['description'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // Gap(10),
                  SizedBox(
                    width: toggleProvider.isSideNavMinimized
                        ? MediaQuery.of(context).size.width * 0.225
                        : MediaQuery.of(context).size.width * 0.3,
                    child: Divider(
                      color: AppUtils.mainGrey(context),
                      thickness: 1,
                    ),
                  ),
                  Text(
                    currentlyViewing['type'] == "recordings"
                        ? AppUtils.formatDuration(
                            Duration(seconds: currentlyViewing['duration']))
                        : "${currentlyViewing['pages'].toString()} pages remainings",
                    style: TextStyle(
                        fontSize: 16, color: AppUtils.mainGrey(context)),
                  ),
                  SizedBox(
                    width: toggleProvider.isSideNavMinimized
                        ? MediaQuery.of(context).size.width * 0.225
                        : MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Icon(FluentIcons.comment_24_regular),
                            Text("0")
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Icon(FluentIcons.thumb_like_24_regular),
                            Text("0")
                          ],
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              String url = AppUtils.$serverDir;
                              // print(url);
                              String lessonName =
                                  currentlyViewing['lesson_name'];
                              List lessonMaterial =
                                  currentlyViewing['lesson_materials'];
                              Map filteredMaterial =
                                  lessonMaterial.firstWhere((material) {
                                return material['id'] ==
                                    currentlyViewing['material_id'];
                              });
                              // print(filteredMaterial);
                              context.go(
                                  '/units/notes/$lessonName/${filteredMaterial['file'].toString().split('/').last}',
                                  extra: {
                                    "path": "$url/${filteredMaterial['file']}",
                                    "material": filteredMaterial,
                                    "featured_material": lessonMaterial,
                                  });
                            },
                            child: Text(
                              "Resume",
                              style: TextStyle(
                                  color: AppUtils.mainBlue(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
