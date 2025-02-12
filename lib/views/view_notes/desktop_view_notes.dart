// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_file_viewer.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_relevant_documents.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_relevant_videos.dart';
import 'package:provider/provider.dart';

class DesktopViewNotes extends StatefulWidget {
  const DesktopViewNotes({super.key});

  @override
  State<DesktopViewNotes> createState() => _DesktopViewNotesState();
}

class _DesktopViewNotesState extends State<DesktopViewNotes> {
  Map material = {};
  List featuredMaterial = [];
  String duration = '';

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

    return Scaffold(
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
        child: Consumer<TogglesProvider>(
            builder: (BuildContext context, togglesProvider, _) {
          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(FluentIcons.arrow_left_24_regular)),
                  Gap(10),
                  Text("Units/Notes/$lessonName/$fileName",
                      style: TextStyle(
                          fontSize: 18, decoration: TextDecoration.underline)),
                ],
              ),
              Gap(20),
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Expanded(
                    flex: 4,
                    child: DesktopFileViewer(
                        fileName: fileName,
                        onPressed: (String videoDuration) {
                          setState(() {
                            duration = videoDuration;
                          });
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppUtils.$mainWhite,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppUtils.$mainGrey)),
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: SingleChildScrollView(
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(material['name'] ?? 'Material Name',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppUtils.$mainBlue)),
                                    Gap(5),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                        color:
                                            AppUtils.$mainBlue.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(lessonName,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppUtils.$mainBlack)),
                                    ),
                                    Gap(10),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        height: 1,
                                        color: AppUtils.$mainGrey),
                                    Gap(10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${fileName.split('.')[1] == 'mp4' ? 'Video' : 'Document'} Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: AppUtils.$mainBlack)),
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
                                          "Duration:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppUtils.$mainBlack),
                                        ),
                                        Gap(5),
                                        Text(
                                          duration,
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Gap(5),
                                    Row(
                                      children: [
                                        Text(
                                          "Uploaded by:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppUtils.$mainBlack),
                                        ),
                                        Gap(5),
                                        Text(
                                          "John Doe",
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
                                              color: AppUtils.$mainBlack),
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
                                Gap(20),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.height / 3,
                                    height: 1,
                                    color: AppUtils.$mainGrey),
                                Gap(20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Other $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.$mainBlue)),
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
                                                  image:
                                                      'assets/images/404.png'))
                                          : Column(
                                              children: featuredMaterial
                                                  .where((mat) =>
                                                      mat['id'] !=
                                                      material['id'])
                                                  .map((filteredMat) =>
                                                      DesktopRelevantVideos(
                                                        material: filteredMat,
                                                      ))
                                                  .toList(),
                                            )
                                    else
                                      featuredMaterial.isEmpty ||
                                              featuredMaterial
                                                  .where((mat) =>
                                                      mat['id'] !=
                                                      material['id'])
                                                  .isEmpty
                                          ? Container(
                                              padding: const EdgeInsets.all(10),
                                              child: EmptyWidget(
                                                  errorHeading: "No Documents",
                                                  errorDescription:
                                                      "No relevant documents found",
                                                  image:
                                                      'assets/images/404.png'),
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
                                                            material:
                                                                filteredMat,
                                                          ))
                                                      .toList(),
                                            ),
                                  ],
                                )
                              ],
                            ),
                          )))
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
