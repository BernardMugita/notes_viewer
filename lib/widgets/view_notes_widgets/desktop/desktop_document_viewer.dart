import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DesktopDocumentViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;

  const DesktopDocumentViewer(
      {super.key, required this.fileName, required this.uploadType});

  @override
  State<DesktopDocumentViewer> createState() => _DesktopDocumentViewerState();
}

class _DesktopDocumentViewerState extends State<DesktopDocumentViewer> {
  String? _pdfFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    final state = GoRouter.of(context).state;

    final path = state!.extra != null ? (state.extra as Map)['path'] : null;

    setState(() {
      _pdfFilePath = path.replaceAll(' ', '%20');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppUtils.$mainWhite, borderRadius: BorderRadius.circular(5)),
      height: MediaQuery.of(context).size.height * 0.95,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.fileName,
                style: TextStyle(
                    color: AppUtils.$mainBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.$mainBlack,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.$mainBlack,
                      )),
                ],
              )
            ],
          ),
          Gap(5),
          Divider(
            color: AppUtils.$mainGrey,
          ),
          Gap(5),
          Expanded(
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: AppUtils.$mainBlue,
                      size: 100,
                    ),
                  )
                : Container(
                  decoration: BoxDecoration(
                    color: AppUtils.$mainBlueAccent
                  ),
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height / 1.25,
                    child: SfPdfViewer.network(
                      _pdfFilePath!,
                      initialZoomLevel: -0.5,
                      headers: <String, String>{
                        'ngrok-skip-browser-warning': 'true',
                      },
                      onDocumentLoadFailed:
                          (PdfDocumentLoadFailedDetails details) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to load PDF: ${details.error}: ${details.description}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
