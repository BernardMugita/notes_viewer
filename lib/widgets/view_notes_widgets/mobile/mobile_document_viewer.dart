import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MobileDocumentViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;

  const MobileDocumentViewer(
      {super.key, required this.fileName, required this.uploadType});

  @override
  State<MobileDocumentViewer> createState() => _MobileDocumentViewerState();
}

class _MobileDocumentViewerState extends State<MobileDocumentViewer> {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  widget.fileName,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: AppUtils.mainBlue(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.mainBlack(context),
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.mainBlack(context),
                      )),
                ],
              )
            ],
          ),
          Gap(5),
          Divider(
            color: AppUtils.mainGrey(context),
          ),
          Gap(5),
          Expanded(
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.newtonCradle(
                      color: AppUtils.mainBlue(context),
                      size: 100,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(5),
                    color: AppUtils.mainBlueAccent(context),
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
          Gap(10),
          SizedBox(
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.center,
              "Page 1/1",
              style: TextStyle(color: AppUtils.mainBlue(context)),
            ),
          )
        ],
      ),
    );
  }
}
