import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_file.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_recording.dart';

class DesktopStudy extends StatelessWidget {
  const DesktopStudy({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Lesson';

    return Scaffold(
        body: Flex(direction: Axis.horizontal, children: [
      Expanded(
        flex: 1,
        child: const SideNavigation(),
      ),
      Expanded(
          flex: 6,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Row(
                  children: [
                    const Gap(5),
                    Text(
                      lessonName,
                      style: TextStyle(
                        fontSize: 30,
                        color: AppUtils.$mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      FluentIcons.doctor_24_regular,
                      size: 34,
                      color: AppUtils.$mainBlue,
                    )
                  ],
                ),
                const Gap(10),
                const Divider(
                  color: Color(0xFFCECECE),
                ),
                const Gap(20),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.25,
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 40, left: 80, right: 80),
                  decoration: BoxDecoration(color: AppUtils.$mainWhite),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Study material",
                          style: TextStyle(
                              fontSize: 24, color: AppUtils.$mainGrey)),
                      const Gap(5),
                      Divider(
                        color: AppUtils.$mainGrey,
                      ),
                      const Gap(20),
                      Wrap(
                        spacing: 40,
                        runSpacing: 40,
                        children: [
                          DesktopRecording(
                            fileName: 'Introduction to Anatomy.mp4',
                            icon: FluentIcons.play_24_filled,
                          ),
                          DesktopRecording(
                            fileName: 'Alex Charangwa Contribution.mp4',
                            icon: FluentIcons.play_24_filled,
                          ),
                          DesktopFile(
                            fileName: 'Philosophy of Anatomy.pdf',
                            icon: FluentIcons.document_pdf_24_regular,
                          ),
                          DesktopFile(
                            fileName: 'Anatomy for Doctors.docx',
                            icon: FluentIcons.document_text_24_regular,
                          ),
                          DesktopFile(
                            fileName: 'Trends in Clinical Anatomy.xlxs',
                            icon: FluentIcons.document_table_24_regular,
                          ),
                          DesktopFile(
                            fileName: 'Memoirs of Anatomy.ppt',
                            icon: FluentIcons.slide_layout_24_regular,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ])))
    ]));
  }
}
