import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopRecording extends StatefulWidget {
  final String fileName;
  final String lesson;
  final Map material;
  final IconData? icon;
  final List recordings;
  final List contributions;

  const DesktopRecording({
    super.key,
    required this.fileName,
    required this.lesson,
    required this.material,
    this.icon,
    required this.recordings,
    required this.contributions,
  });

  @override
  State<DesktopRecording> createState() => _DesktopRecordingState();
}

class _DesktopRecordingState extends State<DesktopRecording> {
  @override
  Widget build(BuildContext context) {
    // final fileExtension = widget.lesson['file'].split('.')[1];

    String uploadType = 'recordings';

    final String url = AppUtils.$serverDir;

    return GestureDetector(
      onTap: () {
        context.go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
          "path":
              "$url/${widget.material['path']}/$uploadType/${widget.fileName}",
          "material": widget.material,
          "featured_material": widget.recordings.isEmpty
              ? widget.contributions
              : widget.recordings,
        });
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppUtils.mainGrey(context))),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppUtils.mainBlueAccent(context),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: AppUtils.mainBlue(context),
                ),
              ),
              Gap(10),
              SizedBox(
                  child: Text(widget.material['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18))),
            ],
          )),
    );
  }
}
