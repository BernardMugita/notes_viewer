// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
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

    print(featuredMaterial);

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            top: 20,
            bottom: 20),
        child: Consumer<TogglesProvider>(
            builder: (BuildContext context, togglesProvider, _) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppUtils.mainBlue(context),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              FluentIcons.alert_24_regular,
                              size: 25,
                              color: AppUtils.mainWhite(context),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: context
                                          .watch<DashboardProvider>()
                                          .isNewActivities
                                      ? AppUtils.mainRed(context)
                                      : AppUtils.mainGrey(context),
                                ))
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              context.go('/settings');
                            },
                            icon: Icon(
                              FluentIcons.settings_24_regular,
                              size: 25,
                              color: AppUtils.mainWhite(context),
                            )),
                        Gap(10),
                        SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            color: AppUtils.mainGrey(context),
                          ),
                        ),
                        Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (context.watch<UserProvider>().isLoading)
                              SizedBox(
                                width: 150,
                                child: LinearProgressIndicator(
                                  minHeight: 1,
                                  color: AppUtils.mainWhite(context),
                                ),
                              )
                            else
                              Text(user.isNotEmpty ? user['username'] : 'Guest',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainWhite(context),
                                      fontWeight: FontWeight.bold)),
                            if (context.watch<UserProvider>().isLoading)
                              SizedBox(
                                width: 50,
                                child: LinearProgressIndicator(
                                  minHeight: 1,
                                  color: AppUtils.mainWhite(context),
                                ),
                              )
                            else
                              SizedBox(
                                width: 150,
                                child: Text(
                                    user.isNotEmpty
                                        ? user['email']
                                        : 'guest@email.com',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: AppUtils.mainWhite(context))),
                              ),
                          ],
                        ),
                        Gap(10),
                        CircleAvatar(
                          child: Icon(FluentIcons.person_24_regular),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          Expanded(
                            flex: 3,
                            child: DesktopFileViewer(
                                fileName: fileName,
                                material: material,
                                onPressed: (Duration videoDuration) {
                                  setState(() {
                                    duration = videoDuration;
                                  });
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.67,
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 20, left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: AppUtils.mainWhite(context),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: AppUtils.mainGrey(context)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Discussion Forum",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppUtils.mainBlue(context))),
                                  Gap(10),
                                  Divider(
                                      height: 1,
                                      color: AppUtils.mainGrey(context)),
                                  Gap(10),
                                  Expanded(
                                      child:
                                          DiscussionForum()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(material['name'] ?? 'Material Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppUtils.mainBlue(context))),
                                Gap(5),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: AppUtils.mainBlue(context)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(lessonName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppUtils.mainBlack(context))),
                                ),
                                Gap(10),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height: 1,
                                    color: AppUtils.mainGrey(context)),
                                Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${fileName.split('.')[1] == 'mp4' ? 'Video' : 'Document'} Description",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                AppUtils.mainBlack(context))),
                                    Gap(5),
                                    Text(
                                        material['description'] ??
                                            'lorem lorem lorem',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Gap(20),
                                Row(
                                  children: [
                                    Text(
                                      "Uploaded by:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppUtils.mainBlack(context)),
                                    ),
                                    Gap(5),
                                    Text(
                                      material['uploader'] ?? 'John Doe',
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                Gap(5),
                                Row(
                                  children: [
                                    Text(
                                      "Date Published:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppUtils.mainBlack(context)),
                                    ),
                                    Gap(5),
                                    Text(
                                      material.isEmpty
                                          ? '01-01-2025'
                                          : AppUtils.formatDate(
                                              material['created_at']),
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Other $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppUtils.mainBlue(context))),
                                  Gap(20),
                                  if (fileName.split('.')[1] == 'mp4')
                                    featuredMaterial
                                            .where((mat) =>
                                                mat['id'] != material['id'])
                                            .isEmpty
                                        ? Container(
                                            padding: const EdgeInsets.all(10),
                                            child: EmptyWidget(
                                                errorHeading: "No videos",
                                                errorDescription:
                                                    "No relevant videos found",
                                                image: 'assets/images/404.png'))
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            child: SingleChildScrollView(
                                              child: Column(
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
                                            ),
                                          )
                                  else
                                    featuredMaterial.isEmpty ||
                                            featuredMaterial
                                                .where((mat) =>
                                                    mat['id'] != material['id'])
                                                .isEmpty
                                        ? Container(
                                            padding: const EdgeInsets.all(10),
                                            child: EmptyWidget(
                                                errorHeading: "No Documents",
                                                errorDescription:
                                                    "No relevant documents found",
                                                image: 'assets/images/404.png'),
                                          )
                                        : Column(
                                            children: featuredMaterial.isEmpty
                                                ? []
                                                : featuredMaterial
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
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
