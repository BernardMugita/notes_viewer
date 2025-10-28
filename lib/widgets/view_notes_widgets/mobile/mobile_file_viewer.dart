import 'package:flutter/material.dart';
import 'package:maktaba/widgets/view_notes_widgets/mobile/mobile_document_viewer.dart';
import 'package:maktaba/widgets/view_notes_widgets/mobile/mobile_video_viewer.dart';

class MobileFileViewer extends StatefulWidget {
  final String fileName;
  final Function onPressed;
  final Map<dynamic, dynamic> material;

  const MobileFileViewer({
    super.key,
    required this.fileName,
    required this.onPressed,
    required this.material,
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
            material: widget.material,
            onPressed: widget.onPressed,
            uploadType: 'recordings',
          )
        : fileExtension == 'docx' ||
                fileExtension == 'xlxs' ||
                fileExtension == 'pdf' ||
                fileExtension == 'ppt'
            ? MobileDocumentViewer(
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
                child: Text(
                  'File not supported',
                  style: TextStyle(fontSize: 20),
                ),
              );
  }
}
