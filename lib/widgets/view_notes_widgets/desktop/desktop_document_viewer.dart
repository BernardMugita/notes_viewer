import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DesktopDocumentViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Map<dynamic, dynamic> material;

  const DesktopDocumentViewer(
      {super.key,
      required this.fileName,
      required this.uploadType,
      required this.material});

  @override
  State<DesktopDocumentViewer> createState() => _DesktopDocumentViewerState();
}

class _DesktopDocumentViewerState extends State<DesktopDocumentViewer> {
  late DashboardProvider dashboardProvider;

  String? _pdfFilePath;
  bool isLoading = true;
  Map currentlyViewing = {};
  Map user = {};
  Map lesson = {};

  int remainingPages = 0;

  void saveCurrentlyViewing(
      Map user,
      Map lesson,
      String materialId,
      String materialName,
      String createdAt,
      String type,
      String description,
      int pages) async {
    currentlyViewing = {
      "user_id": user['id'],
      "lesson_name": lesson['name'],
      "lesson_materials": lesson['materials'],
      "material_id": materialId,
      "name": materialName,
      "created_at": createdAt,
      "type": type,
      "description": description,
      "pages": pages,
    };

    dashboardProvider.saveUsersRecentlyViewedMaterial(currentlyViewing);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    lesson = context.read<LessonsProvider>().lesson;

    final state = GoRouter.of(context).state;

    final path = state!.extra != null ? (state.extra as Map)['path'] : '';

    setState(() {
      _pdfFilePath = path.replaceAll(' ', '%20') ?? '';
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context, listen: false).user;
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
  }

  @override
  void dispose() {
    saveCurrentlyViewing(
        user,
        lesson,
        widget.material['id'],
        widget.material['name'],
        widget.material['created_at'],
        widget.material['type'],
        widget.material['description'],
        remainingPages);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.fileName,
              style: TextStyle(
                  color: AppUtils.mainBlue(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
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
        Gap(10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              border: Border.all(color: AppUtils.mainGrey(context)),
              borderRadius: BorderRadius.circular(5)),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.newtonCradle(
                          color: AppUtils.mainBlue(context),
                          size: 100,
                        ),
                      )
                    : _pdfFilePath!.isEmpty || _pdfFilePath == ''
                        ? EmptyWidget(
                            errorHeading: "No Document!",
                            errorDescription: "Document not found",
                            image: context.watch<ThemeProvider>().isDarkMode
                                ? 'assets/images/404-dark.png'
                                : 'assets/images/404.png')
                        : SfPdfViewer.network(
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
            ],
          ),
        ),
      ],
    );
  }
}
