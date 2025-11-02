import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DesktopDocumentViewer extends StatefulWidget {
  final String fileName;
  final String uploadType;
  final Map<dynamic, dynamic> material;

  const DesktopDocumentViewer({
    super.key,
    required this.fileName,
    required this.uploadType,
    required this.material,
  });

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

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return FluentIcons.document_pdf_24_filled;
      case 'docx':
      case 'doc':
        return FluentIcons.document_24_filled;
      case 'xlsx':
      case 'xls':
        return FluentIcons.document_table_24_filled;
      case 'ppt':
      case 'pptx':
        return FluentIcons.slide_layout_24_filled;
      default:
        return FluentIcons.document_24_filled;
    }
  }

  Color _getFileColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'docx':
      case 'doc':
        return Colors.blue;
      case 'xlsx':
      case 'xls':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      default:
        return Colors.blue;
    }
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
    final fileColor = _getFileColor(widget.fileName);
    final fileIcon = _getFileIcon(widget.fileName);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: fileColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  fileIcon,
                  size: 20,
                  color: fileColor,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  widget.fileName,
                  style: TextStyle(
                    color: AppUtils.mainBlack(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Action buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Like',
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.mainGrey(context),
                        size: 20,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.shade300,
                    ),
                    IconButton(
                      onPressed: () {},
                      tooltip: 'Dislike',
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.mainGrey(context),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Divider(color: Colors.grey.shade200, height: 1),
          const Gap(16),

          // Document Viewer
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.mainBlue(context),
                        size: 100,
                      ),
                    )
                  : _pdfFilePath!.isEmpty || _pdfFilePath == ''
                      ? Center(
                          child: EmptyWidget(
                            errorHeading: "No Document!",
                            errorDescription: "Document not found",
                            type: EmptyWidgetType.notes,
                          ),
                        )
                      : SfPdfViewer.network(
                          _pdfFilePath!,
                          initialZoomLevel: 1.0,
                          headers: <String, String>{
                            'ngrok-skip-browser-warning': 'true',
                          },
                          onDocumentLoadFailed:
                              (PdfDocumentLoadFailedDetails details) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Failed to load document: ${details.error}'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
