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
import 'package:maktaba/responsive/responsive_layout.dart';
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
  String? expandedResultId; // <- Tracks the currently expanded item
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) tokenRef = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: _buildSearchResultItem(10, 10, 200),
      tabletLayout: _buildSearchResultItem(20, 20, 200),
      desktopLayout: _buildSearchResultItem(20, 20, 200),
    );
  }

  Widget _buildSearchResultItem(
      double paddingLeft, double paddingRight, double titleWidth) {
    final themeProvider = context.watch<ThemeProvider>();
    final emptyImage = themeProvider.isDarkMode
        ? 'assets/images/404-dark.png'
        : 'assets/images/404.png';

    if (widget.searchResults.isEmpty) {
      return EmptyWidget(
        errorHeading: "Empty Results",
        errorDescription: "No matches found for '${widget.query}'",
        image: emptyImage,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: widget.searchResults.map((result) {
          final resultId = result['id'];
          final unitId = result['unit_id'];
          String uploadType = (result['type'] ?? 'notes');
          if (uploadType == 'recordings') uploadType = 'recording';

          return Consumer3<TogglesProvider, DashboardProvider, LessonsProvider>(
            builder: (context, toggleProvider, dashboardProvider,
                lessonProvider, _) {
              final dashUnits = dashboardProvider.dashData['units'];
              final unit = dashUnits.firstWhere((u) => u['id'] == unitId);
              final lessons = unit['lessons'];

              final activityLesson = lessons.firstWhere((lesson) {
                final lessonName =
                    lesson['name'].toString().toLowerCase().replaceAll(' ', '');
                final activityName = result['message']
                    .toString()
                    .split(uploadType)[0]
                    .replaceAll('-', '')
                    .toLowerCase()
                    .replaceAll(' ', '');
                return lessonName == activityName;
              });

              final isExpanded = expandedResultId == resultId;

              Future<void> getLessonDetails() async {
                await lessonProvider.getLesson(tokenRef, activityLesson['id']);
              }

              return Container(
                padding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: paddingLeft),
                margin: const EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  color: AppUtils.mainWhite(context),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppUtils.mainGrey(context)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              AppUtils.mainGreen(context).withOpacity(0.3),
                          child: Icon(
                            FluentIcons
                                .text_bullet_list_square_search_20_regular,
                            color: AppUtils.mainGreen(context),
                          ),
                        ),
                        Gap(10),
                        GestureDetector(
                          onTap: () {
                            context.read<UnitsProvider>().setUnitId(unitId);
                            context.go('/units/notes');
                            Future.delayed(const Duration(seconds: 1), () {
                              toggleProvider.deActivateSearchMode();
                            });
                          },
                          child: SizedBox(
                            width: titleWidth,
                            child: Text(
                              result['title'] ?? 'Loading . . .',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await getLessonDetails();
                            setState(() {
                              // Toggle: collapse if already expanded, else expand this item
                              expandedResultId = isExpanded ? null : resultId;
                            });
                          },
                          child: Icon(
                            isExpanded
                                ? FluentIcons.chevron_up_24_filled
                                : FluentIcons.chevron_down_24_filled,
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded)
                      Column(
                        children: [
                          Divider(
                            color: AppUtils.mainBlueAccent(context),
                            indent: 10,
                          ),
                          ListTile(
                            onTap: () {
                              final lesson = lessonProvider.lesson;
                              final materialList =
                                  (lesson['materials'][uploadType] as List);
                              final material = materialList.firstWhere(
                                  (m) => m['id'] == result['material_id']);
                              final url = AppUtils.$serverDir;

                              context.go(
                                '/units/notes/${lesson['name']}/${material['file'].toString().split('/').last}',
                                extra: {
                                  "path": "$url/${material['file']}",
                                  "material": material,
                                  "featured_material": materialList,
                                },
                              );
                              Future.delayed(const Duration(seconds: 1), () {
                                toggleProvider.deActivateSearchMode();
                              });
                            },
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            title: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      _getMaterialColor(uploadType, context)
                                          .withOpacity(0.2),
                                  child: Icon(
                                    _getMaterialIcon(uploadType),
                                    color:
                                        _getMaterialColor(uploadType, context),
                                  ),
                                ),
                                const Gap(10),
                                Expanded(child: Text(result['message'])),
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
        }).toList(),
      ),
    );
  }

  IconData _getMaterialIcon(String type) {
    switch (type) {
      case 'notes':
        return FluentIcons.book_24_regular;
      case 'slides':
        return FluentIcons.slide_content_24_regular;
      case 'recording':
        return FluentIcons.video_24_regular;
      case 'student_contributions':
        return FluentIcons.people_20_regular;
      default:
        return FluentIcons.person_24_regular;
    }
  }

  Color _getMaterialColor(String type, BuildContext context) {
    switch (type) {
      case 'notes':
        return Colors.purpleAccent;
      case 'slides':
        return Colors.amber;
      case 'recording':
        return AppUtils.mainBlue(context);
      case 'student_contributions':
        return Colors.deepOrange;
      default:
        return AppUtils.mainGreen(context);
    }
  }
}
