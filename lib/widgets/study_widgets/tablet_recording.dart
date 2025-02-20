import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletRecording extends StatefulWidget {
  final String fileName;
  final String lesson;
  final Map material;
  final IconData? icon;
  final List recordings;
  final List contributions;

  const TabletRecording({
    super.key,
    required this.fileName,
    required this.lesson,
    required this.material,
    this.icon,
    required this.recordings,
    required this.contributions,
  });

  @override
  State<TabletRecording> createState() => _TabletRecordingState();
}

class _TabletRecordingState extends State<TabletRecording> {
  @override
  Widget build(BuildContext context) {
    String uploadType = 'recordings';

    final String url = AppUtils.$baseUrl;

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
                  child: Text(widget.fileName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18))),
            ],
          )),
    );
  }
}
