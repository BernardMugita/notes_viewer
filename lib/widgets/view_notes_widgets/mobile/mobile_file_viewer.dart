import 'package:flutter/material.dart';
import 'package:note_viewer/widgets/view_notes_widgets/mobile/mobile_document_viewer.dart';
import 'package:note_viewer/widgets/view_notes_widgets/mobile/mobile_video_viewer.dart';

class MobileFileViewer extends StatefulWidget {
  final String fileName;
  final Function onPressed;

  const MobileFileViewer({
    super.key,
    required this.fileName,
    required this.onPressed,
  });

  @override
  State<MobileFileViewer> createState() => _MobileFileViewerState();
}

class _MobileFileViewerState extends State<MobileFileViewer> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    return fileExtension == 'mp4' || fileExtension == 'webm'
        ? MobileVideoViewer(
            fileName: widget.fileName,
            onPressed: widget.onPressed,
            uploadType: 'recordings',
          )
        : fileExtension == 'docx' ||
                fileExtension == 'xlxs' ||
                fileExtension == 'pdf' ||
                fileExtension == 'ppt'
            ? MobileDocumentViewer(
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
