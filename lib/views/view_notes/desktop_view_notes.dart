import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/desktop_file_viewer.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/desktop_relevant_documents.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/desktop_relevant_videos.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/discussion_forum.dart';
import 'package:provider/provider.dart';

class DesktopViewNotes extends StatefulWidget {
  const DesktopViewNotes({super.key});

  @override
  State<DesktopViewNotes> createState() => _DesktopViewNotesState();
}

class _DesktopViewNotesState extends State<DesktopViewNotes> {
  Map material = {};
  List featuredMaterial = [];
  Duration duration = const Duration(milliseconds: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouter.of(context).state;

      setState(() {
        material =
            state!.extra != null ? (state.extra as Map)['material'] : null;
        featuredMaterial = state.extra != null
            ? (state.extra as Map)['featured_material']
            : {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final fileName = args?['fileName'] as String? ?? 'File';
    final lessonName = args?['lesson'] as String? ?? 'Lesson';
    final user = context.watch<UserProvider>().user;

    Logger logger = Logger();
    logger.log(Level.info, material);

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          top: 20,
          bottom: 20,
        ),
        child: Consumer<TogglesProvider>(
          builder: (BuildContext context, togglesProvider, _) {
            return Column(
              spacing: 20,
              children: [
                // Top Bar
                _buildTopBar(
                  context,
                  user,
                  context.watch<DashboardProvider>().isNewActivities,
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: [
                        // Main Viewer and Discussion Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 20,
                          children: [
                            // File Viewer (Left - 70%)
                            Expanded(
                              flex: 7,
                              child: DesktopFileViewer(
                                fileName: fileName,
                                material: material,
                                onPressed: (Duration videoDuration) {
                                  setState(() {
                                    duration = videoDuration;
                                  });
                                },
                              ),
                            ),

                            // Discussion Forum (Right - 30%)
                            Expanded(
                              flex: 3,
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height * 0.725,
                                ),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppUtils.mainWhite(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppUtils.mainBlue(context)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            FluentIcons.chat_24_filled,
                                            size: 20,
                                            color: AppUtils.mainBlue(context),
                                          ),
                                        ),
                                        const Gap(12),
                                        Text(
                                          "Discussion Forum",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppUtils.mainBlack(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(16),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    const Gap(16),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.55,
                                      child: DiscussionForum(
                                        studyMaterialId: material['id'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Material Details and Related Content
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 20,
                          children: [
                            // Material Details (Left - 70%)
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppUtils.mainWhite(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Material Title and Badge
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            material['name'] ?? 'Material Name',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AppUtils.mainBlack(context),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppUtils.mainBlue(context)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            lessonName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppUtils.mainBlue(context),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    const Gap(20),

                                    // Description Section
                                    Text(
                                      "${fileName.split('.')[1] == 'mp4' ? 'Video' : 'Document'} Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppUtils.mainBlack(context),
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      material['description'] ??
                                          'No description available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppUtils.mainGrey(context),
                                        height: 1.5,
                                      ),
                                    ),
                                    const Gap(24),

                                    // Metadata Row
                                    Wrap(
                                      spacing: 24,
                                      runSpacing: 12,
                                      children: [
                                        _buildMetadataItem(
                                          context,
                                          FluentIcons.person_24_regular,
                                          'Uploaded by',
                                          material['uploader'] ?? 'John Doe',
                                        ),
                                        _buildMetadataItem(
                                          context,
                                          FluentIcons.calendar_24_regular,
                                          'Date Published',
                                          material.isEmpty
                                              ? '01-01-2025'
                                              : AppUtils.formatDate(
                                                  material['created_at']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Related Materials (Right - 30%)
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppUtils.mainWhite(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppUtils.mainBlue(context)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            fileName.split('.')[1] == 'mp4'
                                                ? FluentIcons.video_24_filled
                                                : FluentIcons
                                                    .document_24_filled,
                                            size: 18,
                                            color: AppUtils.mainBlue(context),
                                          ),
                                        ),
                                        const Gap(12),
                                        Expanded(
                                          child: Text(
                                            "Related $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppUtils.mainBlack(context),
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(16),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    const Gap(16),

                                    // Related Materials List
                                    if (fileName.split('.')[1] == 'mp4')
                                      featuredMaterial
                                              .where((mat) =>
                                                  mat['id'] != material['id'])
                                              .isEmpty
                                          ? Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: EmptyWidget(
                                                  errorHeading: "No videos",
                                                  errorDescription:
                                                      "No related videos found",
                                                  type: EmptyWidgetType.notes,
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: ListView(
                                                children: featuredMaterial
                                                    .where((mat) =>
                                                        mat['id'] !=
                                                        material['id'])
                                                    .map((filteredMat) =>
                                                        DesktopRelevantVideos(
                                                          material: filteredMat,
                                                        ))
                                                    .toList(),
                                              ),
                                            )
                                    else
                                      featuredMaterial.isEmpty ||
                                              featuredMaterial
                                                  .where((mat) =>
                                                      mat['id'] !=
                                                      material['id'])
                                                  .isEmpty
                                          ? Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: EmptyWidget(
                                                  errorHeading: "No Documents",
                                                  errorDescription:
                                                      "No related documents found",
                                                  type: EmptyWidgetType.notes,
                                                ),
                                              ),
                                            )
                                          : ListView(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              children: featuredMaterial
                                                  .where((mat) =>
                                                      mat['id'] !=
                                                      material['id'])
                                                  .map((filteredMat) =>
                                                      DesktopRelevantDocuments(
                                                        material: filteredMat,
                                                      ))
                                                  .toList(),
                                            ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, Map<dynamic, dynamic> user, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              FluentIcons.arrow_left_24_filled,
              color: AppUtils.mainWhite(context),
            ),
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.alert_24_regular,
                      size: 24,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                  if (isNewActivities)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppUtils.mainRed(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(8),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  user.isNotEmpty ? user['username'][0].toUpperCase() : 'G',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppUtils.mainBlue(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppUtils.mainBlue(context),
          ),
        ),
        const Gap(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppUtils.mainGrey(context),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppUtils.mainBlack(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
