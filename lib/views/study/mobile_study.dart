import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/study_widgets/mobile_file.dart';
import 'package:note_viewer/widgets/study_widgets/mobile_recording.dart';

class MobileStudy extends StatelessWidget {
  MobileStudy({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final lessonName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Lesson';

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(FluentIcons.re_order_24_regular),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(
                children: [
                  const Gap(5),
                  Text(
                    lessonName,
                    style: TextStyle(
                      fontSize: 24,
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
              Expanded(
                child: Container(
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height / 1.45,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppUtils.$mainWhite),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Study material",
                            style: TextStyle(
                                fontSize: 18, color: AppUtils.$mainGrey)),
                        const Gap(5),
                        Divider(
                          color: AppUtils.$mainGrey,
                        ),
                        const Gap(20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            MobileRecording(
                              fileName: 'Introduction to Anatomy.mp4',
                              icon: FluentIcons.play_24_filled,
                            ),
                            MobileRecording(
                              fileName: 'Alex Charangwa Contribution.mp4',
                              icon: FluentIcons.play_24_filled,
                            ),
                            MobileFile(
                              fileName: 'Philosophy of Anatomy.pdf',
                              icon: FluentIcons.document_pdf_24_regular,
                            ),
                            MobileFile(
                              fileName: 'Anatomy for Doctors.docx',
                              icon: FluentIcons.document_text_24_regular,
                            ),
                            MobileFile(
                              fileName: 'Trends in Clinical Anatomy.xlxs',
                              icon: FluentIcons.document_table_24_regular,
                            ),
                            MobileFile(
                              fileName: 'Memoirs of Anatomy.ppt',
                              icon: FluentIcons.slide_layout_24_regular,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }
}
