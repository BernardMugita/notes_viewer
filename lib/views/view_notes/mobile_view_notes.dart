import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:note_viewer/widgets/view_notes_widgets/mobile/mobile_file_viewer.dart';
import 'package:note_viewer/widgets/view_notes_widgets/mobile/mobile_relevant_documents.dart';
import 'package:note_viewer/widgets/view_notes_widgets/mobile/mobile_relevant_videos.dart';
import 'package:provider/provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';

class MobileViewNotes extends StatefulWidget {
  const MobileViewNotes({super.key});

  @override
  State<MobileViewNotes> createState() => _MobileViewNotesState();
}

class _MobileViewNotesState extends State<MobileViewNotes> {
  Map material = {};
  List featuredMaterial = [];
  String duration = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouter.of(context).state;
      setState(() {
        material = state!.extra != null ? (state.extra as Map)['material'] : {};
        featuredMaterial = state.extra != null
            ? (state.extra as Map)['featured_material']
            : [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final fileName = args?['fileName'] as String? ?? 'File';
    final lessonName = args?['lesson'] as String? ?? 'Lesson';

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(FluentIcons.arrow_left_24_regular),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<TogglesProvider>(
          builder: (context, togglesProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MobileFileViewer(
                  fileName: fileName,
                  onPressed: (String videoDuration) {
                    setState(() {
                      duration = videoDuration;
                    });
                  },
                ),
                Gap(10),
                Divider(color: AppUtils.$mainGrey),
                Gap(10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppUtils.$mainWhite,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppUtils.$mainGrey),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(material['name'] ?? 'Material Name',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppUtils.$mainBlue)),
                      Gap(5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppUtils.$mainBlue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(lessonName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppUtils.$mainBlack)),
                      ),
                      Gap(10),
                      Divider(color: AppUtils.$mainGrey),
                      Gap(10),
                      Text(
                          "${fileName.split('.')[1] == 'mp4' ? 'Video' : 'Document'} Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppUtils.$mainBlack)),
                      Gap(5),
                      Text(
                          material['description'] ?? 'No description available',
                          style: TextStyle(fontSize: 16)),
                      Gap(20),
                      Row(
                        children: [
                          Text("Uploaded by:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppUtils.$mainBlack)),
                          Gap(5),
                          Text("John Doe", style: TextStyle(fontSize: 16))
                        ],
                      ),
                      Gap(5),
                      Row(
                        children: [
                          Text("Date Published:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppUtils.$mainBlack)),
                          Gap(5),
                          Text(
                            material.isEmpty
                                ? '01-01-2025'
                                : AppUtils.formatDate(material['created_at']),
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Gap(20),
                      Divider(color: AppUtils.$mainGrey),
                      Gap(20),
                      Text(
                          "Other $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                          style: TextStyle(
                              fontSize: 18, color: AppUtils.$mainBlue)),
                      Gap(20),
                      if (fileName.split('.')[1] == 'mp4')
                        featuredMaterial.isEmpty
                            ? EmptyWidget(
                                errorHeading: "No Videos",
                                errorDescription: "No relevant videos found",
                                image: 'assets/images/404.png')
                            : Column(
                                children: featuredMaterial
                                    .where((mat) => mat['id'] != material['id'])
                                    .map((filteredMat) => MobileRelevantVideos(
                                          material: filteredMat,
                                        ))
                                    .toList(),
                              )
                      else
                        featuredMaterial.isEmpty
                            ? EmptyWidget(
                                errorHeading: "No Documents",
                                errorDescription: "No relevant documents found",
                                image: 'assets/images/404.png')
                            : Column(
                                children: featuredMaterial
                                    .where((mat) => mat['id'] != material['id'])
                                    .map((filteredMat) =>
                                        MobileRelevantDocuments(
                                          material: filteredMat,
                                        ))
                                    .toList(),
                              ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
