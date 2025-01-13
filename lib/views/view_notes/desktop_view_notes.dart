import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_file_viewer.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_relevant_documents.dart';
import 'package:note_viewer/widgets/view_notes_widgets/desktop/desktop_relevant_videos.dart';

class DesktopViewNotes extends StatelessWidget {
  const DesktopViewNotes({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final fileName = args?['fileName'] as String? ?? 'File';
    final lessonName = args?['lessonName'] as String? ?? 'Lesson';

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(FluentIcons.arrow_left_24_regular),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
        child: Column(
          children: [
            DesktopFileViewer(fileName: fileName),
            Gap(10),
            Divider(
              color: AppUtils.$mainGrey,
            ),
            Gap(10),
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppUtils.$mainWhite,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fileName.split('.')[0],
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppUtils.$mainBlue)),
                          Gap(5),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: AppUtils.$mainBlueAccent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(lessonName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
                              Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et"
                                  " dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris"
                                  " nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in"
                                  " voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occ"
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et"
                                  " dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris"
                                  " nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in"
                                  " voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occ",
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
                                "45 ${fileName.split('.')[1] == 'mp4' ? 'minutes' : 'seconds read'}",
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
                                "2022-01-01",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(20),
                    Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: 1,
                        color: AppUtils.$mainGrey),
                    Gap(20),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Other $lessonName ${fileName.split('.')[1] == 'mp4' ? 'Videos' : 'Documents'}",
                                style: TextStyle(
                                    fontSize: 18, color: AppUtils.$mainBlue)),
                            Gap(20),
                            if (fileName.split('.')[1] == 'mp4')
                              Column(
                                children: [
                                  DesktopRelevantVideos(),
                                  DesktopRelevantVideos(),
                                  DesktopRelevantVideos(),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  DesktopRelevantDocuments(),
                                  DesktopRelevantDocuments(),
                                  DesktopRelevantDocuments(),
                                ],
                              ),
                          ],
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}