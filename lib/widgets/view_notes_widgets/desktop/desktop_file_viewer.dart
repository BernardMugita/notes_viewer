import 'package:flutter/material.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/desktop_document_viewer.dart';
import 'package:maktaba/widgets/view_notes_widgets/desktop/desktop_video_viewer.dart';

class DesktopFileViewer extends StatefulWidget {
  final String fileName;
  final Function(Duration duration) onPressed;

  const DesktopFileViewer({
    super.key,
    required this.fileName,
    required this.onPressed,
  });

  @override
  State<DesktopFileViewer> createState() => _DesktopFileViewerState();
}

class _DesktopFileViewerState extends State<DesktopFileViewer> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    return fileExtension == 'mp4' ||
            fileExtension == 'webm' ||
            fileExtension == 'hls' ||
            fileExtension == 'ts' ||
            fileExtension == 'm3u8'
        ? DesktopVideoViewer(
            fileName: widget.fileName,
            onPressed: widget.onPressed,
            uploadType: 'recordings',
          )
        : fileExtension == 'docx' ||
                fileExtension == 'xlxs' ||
                fileExtension == 'pdf' ||
                fileExtension == 'ppt'
            ? DesktopDocumentViewer(
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
