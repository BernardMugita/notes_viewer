import 'package:flutter/material.dart';
import 'package:maktaba/widgets/view_notes_widgets/tablet/tablet_document_viewer.dart';
import 'package:maktaba/widgets/view_notes_widgets/tablet/tablet_video_viewer.dart';

class TabletFileViewer extends StatefulWidget {
  final String fileName;
  final Function onPressed;
  final Map<dynamic, dynamic> material;

  const TabletFileViewer({
    super.key,
    required this.fileName,
    required this.onPressed,
    required this.material,
  });

  @override
  State<TabletFileViewer> createState() => _TabletFileViewerState();
}

class _TabletFileViewerState extends State<TabletFileViewer> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    return fileExtension == 'mp4' ||
            fileExtension == 'webm' ||
            fileExtension == 'hls' ||
            fileExtension == 'ts' ||
            fileExtension == 'm3u8'
        ? TabletVideoViewer(
            fileName: widget.fileName,
            material: widget.material,
            onPressed: widget.onPressed,
            uploadType: 'recordings',
          )
        : fileExtension == 'docx' ||
                fileExtension == 'xlxs' ||
                fileExtension == 'pdf' ||
                fileExtension == 'ppt'
            ? TabletDocumentViewer(
                fileName: widget.fileName,
                material: widget.material,
                uploadType: fileExtension == 'docx' ||
                        fileExtension == 'xlxs' ||
                        fileExtension == 'pdf'
                    ? 'notes'
                    : 'slides',
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'File not supported',
                  style: TextStyle(fontSize: 20),
                ),
              );
  }
}
