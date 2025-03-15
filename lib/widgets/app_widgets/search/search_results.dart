import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatefulWidget {
  final List searchResults;
  final String query;
  final String target;

  const SearchResults(
      {super.key,
      required this.searchResults,
      required this.query,
      required this.target});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  Map toggledSearchItem = {};
  bool isToggledSearchItem = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        child: widget.searchResults.isEmpty
            ? EmptyWidget(
                errorHeading: "Empty Results",
                errorDescription: "No matches found for '${widget.query}'",
                image: context.watch<ThemeProvider>().isDarkMode
                    ? 'assets/images/404-dark.png'
                    : 'assets/images/404.png')
            : Column(
                spacing: 2.5,
                children: widget.searchResults.map((result) {
                  String uploadType = result['type'] ?? 'notes';
                  final unitId = result['unit_id'];

                  if (uploadType != '' &&
                      uploadType.isNotEmpty &&
                      uploadType == 'recordings') {
                    uploadType = uploadType.substring(0, uploadType.length - 1);
                  }

                  return Consumer3<TogglesProvider, DashboardProvider,
                      LessonsProvider>(
                    builder: (BuildContext context, toggleProvider,
                        dashboardProvider, lessonProvider, _) {
                      List dashUnits = dashboardProvider.dashData['units'];
                      final unit = dashUnits.firstWhere((unit) {
                        return unit['id'] == unitId;
                      });
                      List lessons = unit['lessons'];

                      final activityLesson = lessons.firstWhere((lesson) {
                        String lessonName =
                            lesson['name'].toString().toLowerCase();
                        String activityLessonName = result['message']
                            .toString()
                            .split(uploadType)[0]
                            .replaceAll('-', '')
                            .toLowerCase();

                        return lessonName.replaceAll(' ', '') ==
                            activityLessonName.replaceAll(' ', '');
                      });

                      Future<void> getLessonDetailsFromActivityLesson() async {
                        await lessonProvider.getLesson(
                            tokenRef, activityLesson['id']);
                      }

                      return Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: AppUtils.mainWhite(context),
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: AppUtils.mainGrey(context))),
                        child: Column(
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppUtils.mainGreen(context)
                                      .withOpacity(0.3),
                                  child: Icon(
                                    FluentIcons
                                        .text_bullet_list_square_search_20_regular,
                                    color: AppUtils.mainGreen(context),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<UnitsProvider>()
                                        .setUnitId(unitId);
                                    context.go('/units/notes');
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      toggleProvider.deActivateSearchMode();
                                    });
                                  },
                                  child: Text(
                                    result['title'] ?? 'Loading . . .',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    toggleProvider.toggleIsSearchItemExpanded();
                                    await getLessonDetailsFromActivityLesson();
                                    setState(() {
                                      if (toggledSearchItem.isNotEmpty) {
                                        toggledSearchItem = {};
                                      } else {
                                        toggledSearchItem = result;
                                      }
                                      isToggledSearchItem =
                                          toggledSearchItem['id'] ==
                                              result['id'];
                                    });
                                  },
                                  child: (toggleProvider.isSearchItemExpanded &&
                                          isToggledSearchItem)
                                      ? Icon(FluentIcons.chevron_up_24_filled)
                                      : Icon(
                                          FluentIcons.chevron_down_24_filled),
                                )
                              ],
                            ),
                            if (toggleProvider.isSearchItemExpanded &&
                                isToggledSearchItem)
                              Column(
                                children: [
                                  Divider(
                                    color: AppUtils.mainBlueAccent(context),
                                    indent: 10,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      String url = AppUtils.$serverDir;
                                      Map lesson = lessonProvider.lesson;
                                      Map filteredMaterial =
                                          (lesson['materials'][uploadType]
                                                  as List)
                                              .firstWhere((material) {
                                        return material['id'] ==
                                            result['material_id'];
                                      });
                                      context.go(
                                          '/units/notes/${lesson['name']}/${filteredMaterial['file'].toString().split('/').last}',
                                          extra: {
                                            "path":
                                                "$url/${filteredMaterial['file']}",
                                            "material": filteredMaterial,
                                            "featured_material":
                                                lesson['materials'][uploadType],
                                          });
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        toggleProvider.deActivateSearchMode();
                                      });
                                    },
                                    contentPadding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: uploadType ==
                                                      'notes'
                                                  ? Colors.purpleAccent
                                                      .withOpacity(0.2)
                                                  : uploadType == 'slides'
                                                      ? Colors.amber
                                                          .withOpacity(0.2)
                                                      : uploadType ==
                                                              'recordings'
                                                          ? AppUtils.mainBlue(
                                                                  context)
                                                              .withOpacity(0.2)
                                                          : uploadType ==
                                                                  "student_contributions"
                                                              ? Colors
                                                                  .deepOrange
                                                                  .withOpacity(
                                                                      0.2)
                                                              : AppUtils.mainGreen(
                                                                      context)
                                                                  .withOpacity(
                                                                      0.2),
                                              child: Icon(
                                                uploadType == 'notes'
                                                    ? FluentIcons
                                                        .book_24_regular
                                                    : uploadType == 'slides'
                                                        ? FluentIcons
                                                            .slide_content_24_regular
                                                        : uploadType ==
                                                                'recordings'
                                                            ? FluentIcons
                                                                .video_24_regular
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
                                                        : uploadType ==
                                                                'recordings'
                                                            ? AppUtils.mainBlue(
                                                                context)
                                                            : uploadType ==
                                                                    "student_contributions"
                                                                ? Colors
                                                                    .deepOrange
                                                                : AppUtils
                                                                    .mainGreen(
                                                                        context),
                                              ),
                                            ),
                                            Gap(10),
                                            Expanded(
                                                child: Text(result['message'])),
                                          ],
                                        )
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
                }).toList()));
  }
}
