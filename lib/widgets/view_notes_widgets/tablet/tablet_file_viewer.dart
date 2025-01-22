import 'package:flutter/material.dart';
import 'package:note_viewer/widgets/view_notes_widgets/tablet/tablet_document_viewer.dart';
import 'package:note_viewer/widgets/view_notes_widgets/tablet/tablet_video_viewer.dart';

class TabletFileViewer extends StatefulWidget {
  final String fileName;

  const TabletFileViewer({
    super.key,
    required this.fileName,
  });

  @override
  State<TabletFileViewer> createState() => _TabletFileViewerState();
}

class _TabletFileViewerState extends State<TabletFileViewer> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    return fileExtension == 'mp4' || fileExtension == 'webm'
        ? TabletVideoViewer(
            fileName: widget.fileName,
            uploadType: 'recordings',
          )
        : fileExtension == 'docx' ||
                fileExtension == 'xlxs' ||
                fileExtension == 'pdf' ||
                fileExtension == 'ppt'
            ? TabletDocumentViewer(
                fileName: widget.fileName,
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
                child: Text(
                  'File not supported',
                  style: TextStyle(fontSize: 20),
                ),
              );
  }
}
