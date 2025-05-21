import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/dashboard_widgets/recently_viewed/recently_viewed.dart';
import 'package:provider/provider.dart';

class RecentProgress extends StatelessWidget {
  const RecentProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: Consumer<DashboardProvider>(
            builder: (BuildContext context, dashboardProvider, _) {
          final currentlyViewing = dashboardProvider.currentlyViewing;

          return Container(
            decoration: BoxDecoration(
                color: AppUtils.mainWhite(context),
                border: Border.all(
                  color: AppUtils.mainGrey(context),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(FluentIcons.fast_forward_24_regular,
                          color: AppUtils.mainBlue(context)),
                      Text("Continue where you left off",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppUtils.mainBlue(context),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Divider(
                  color: AppUtils.mainGrey(context),
                ),
                if (currentlyViewing.isNotEmpty)
                  Consumer2<DashboardProvider, TogglesProvider>(
                    builder: (BuildContext context, dashboardProvider,
                        toggleProvider, _) {
                      final currentlyViewing =
                          dashboardProvider.currentlyViewing;
                      final uploadType = currentlyViewing['type'];

                      return Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppUtils.mainGrey(context)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          spacing: 20,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppUtils.mainGrey(context)),
                                  borderRadius: BorderRadius.circular(200)),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: uploadType == 'notes'
                                    ? Colors.purpleAccent.withOpacity(0.2)
                                    : uploadType == 'slides'
                                        ? Colors.amber.withOpacity(0.2)
                                        : uploadType == 'recordings' ||
                                                uploadType == 'recording'
                                            ? AppUtils.mainBlue(context)
                                                .withOpacity(0.2)
                                            : uploadType ==
                                                    "student_contributions"
                                                ? Colors.deepOrange
                                                    .withOpacity(0.2)
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
                                              : uploadType ==
                                                      "student_contributions"
                                                  ? FluentIcons
                                                      .people_20_regular
                                                  : FluentIcons
                                                      .person_24_regular,
                                  color: uploadType == 'notes'
                                      ? Colors.purpleAccent
                                      : uploadType == 'slides'
                                          ? Colors.amber
                                          : uploadType == 'recordings' ||
                                                  uploadType == 'recording'
                                              ? AppUtils.mainBlue(context)
                                              : uploadType ==
                                                      "student_contributions"
                                                  ? Colors.deepOrange
                                                  : AppUtils.mainGreen(context),
                                  size: 100,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Divider(
                                color: AppUtils.mainGrey(context),
                                thickness: 1,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    currentlyViewing['description'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                // Gap(10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Divider(
                                    color: AppUtils.mainGrey(context),
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  currentlyViewing['type'] == "recordings"
                                      ? AppUtils.formatDuration(Duration(
                                          seconds:
                                              currentlyViewing['duration']))
                                      : "${currentlyViewing['pages'].toString()} pages remainings",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainGrey(context)),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                                          Icon(FluentIcons
                                              .thumb_like_24_regular),
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
                                            Map lessonMaterial =
                                                currentlyViewing[
                                                    'lesson_materials'];
                                            Map filteredMaterial =
                                                (lessonMaterial as List)
                                                    .firstWhere((material) {
                                              return material['id'] ==
                                                  currentlyViewing[
                                                      'material_id'];
                                            });
                                            // print(filteredMaterial);
                                            context.go(
                                                '/units/notes/$lessonName/${filteredMaterial['file'].toString().split('/').last}',
                                                extra: {
                                                  "path":
                                                      "$url/${filteredMaterial['file']}",
                                                  "material": filteredMaterial,
                                                  "featured_material":
                                                      lessonMaterial,
                                                });
                                          },
                                          child: Text(
                                            "Resume",
                                            style: TextStyle(
                                                color:
                                                    AppUtils.mainBlue(context),
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
                  )
                else
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        // height: 70,
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppUtils.mainWhite(context),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: AppUtils.mainGrey(context)),
                        ),
                        child: Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.prohibited_24_regular,
                              color: AppUtils.mainRed(context),
                              size: 40,
                            ),
                            Text("No recently viewed books",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppUtils.mainGrey(context))),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          );
        }),
        tabletLayout: _buildRecentProgessContainer(),
        desktopLayout: _buildRecentProgessContainer());
  }

  Widget _buildRecentProgessContainer() {
    return Consumer<DashboardProvider>(
        builder: (BuildContext context, dashboardProvider, _) {
      final currentlyViewing = dashboardProvider.currentlyViewing;

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppUtils.mainWhite(context),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppUtils.mainGrey(context)),
        ),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(FluentIcons.fast_forward_24_regular,
                    color: AppUtils.mainBlue(context)),
                Text("Continue where you left off",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppUtils.mainBlue(context),
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Divider(
              color: AppUtils.mainGrey(context),
            ),
            if (currentlyViewing.isNotEmpty)
              RecentlyViewed()
            else
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppUtils.mainWhite(context),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppUtils.mainGrey(context)),
                    ),
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.prohibited_24_regular,
                          color: AppUtils.mainRed(context),
                          size: 40,
                        ),
                        Text("No recently viewed books",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppUtils.mainGrey(context))),
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
}
