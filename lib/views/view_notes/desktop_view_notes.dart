// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';
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
            : null;
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
          return Stack(
            children: [
              DesktopFileViewer(
                  fileName: fileName,
                  onPressed: (String videoDuration) {
                    setState(() {
                      duration = videoDuration;
                    });
                  }),
              Positioned(
                  top: 20,
                  right: 100,
                  child: IconButton(
                    onPressed: () {
                      togglesProvider.toggleDocumentMeta();
                    },
                    icon: togglesProvider.showDocumentMeta
                        ? const Icon(
                            FluentIcons.dismiss_24_regular,
                            color: AppUtils.$mainBlue,
                          )
                        : const Icon(
                            FluentIcons.info_24_regular,
                            color: AppUtils.$mainBlue,
                          ),
                  )),
              if (togglesProvider.showDocumentMeta)
                Positioned(
                  top: 70,
                  right: 20,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: AppUtils.$mainWhite,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(77, 0, 0, 0),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(5, 3),
                            )
                          ]),
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.8,
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppUtils.$mainBlue)),
                                Gap(5),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: AppUtils.$mainGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(lessonName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppUtils.$mainBlack)),
                                ),
                                Gap(10),
                                Divider(
                                  color: AppUtils.$mainGrey,
                                ),
                                Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${fileName.split('.')[1] == 'mp4' ? 'Video' : 'Document'} Description",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppUtils.$mainBlack)),
                                    Gap(5),
                                    Text(material['description'],
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Gap(20),
                                Row(
                                  children: [
                                    Text(
                                      "Duration:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: AppUtils.$mainBlack),
                                    ),
                                    Gap(5),
                                    Text(
                                      duration,
                                      style: TextStyle(fontSize: 18),
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
                                          fontSize: 18,
                                          color: AppUtils.$mainBlack),
                                    ),
                                    Gap(5),
                                    Text(
                                      "John Doe",
                                      style: TextStyle(fontSize: 18),
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
                                          fontSize: 18,
                                          color: AppUtils.$mainBlack),
                                    ),
                                    Gap(5),
                                    Text(
                                      AppUtils.formatDate(
                                          material['created_at']),
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Gap(20),
                            Container(
                                width: MediaQuery.of(context).size.height / 3,
                                height: 1,
                                color: AppUtils.$mainGrey),
                            Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Other $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppUtils.$mainBlue)),
                                Gap(20),
                                if (fileName.split('.')[1] == 'mp4')
                                  featuredMaterial
                                          .where((mat) =>
                                              mat['id'] != material['id'])
                                          .isEmpty
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Icon(
                                                  FluentIcons
                                                      .prohibited_24_filled,
                                                  size: 100,
                                                  color: AppUtils.$mainRed,
                                                ),
                                                Text(
                                                    'No relevant videos found'),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: featuredMaterial
                                              .where((mat) =>
                                                  mat['id'] != material['id'])
                                              .map((filteredMat) =>
                                                  DesktopRelevantVideos(
                                                    material: filteredMat,
                                                  ))
                                              .toList(),
                                        )
                                else
                                  featuredMaterial
                                          .where((mat) =>
                                              mat['id'] != material['id'])
                                          .isEmpty
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Icon(
                                                  FluentIcons
                                                      .prohibited_24_filled,
                                                  size: 100,
                                                  color: AppUtils.$mainRed,
                                                ),
                                                Text(
                                                    'No relevant documents found'),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: featuredMaterial
                                              .where((mat) =>
                                                  mat['id'] != material['id'])
                                              .map((filteredMat) =>
                                                  DesktopRelevantDocuments(
                                                    material: filteredMat,
                                                  ))
                                              .toList(),
                                        ),
                              ],
                            )
                          ],
                        ),
                      )),
                )
            ],
          );
        }),
      ),
    );
  }
}
