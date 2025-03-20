import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/utils/app_utils.dart';

class MobileRecording extends StatefulWidget {
  final String fileName;
  final String lesson;
  final Map material;
  final IconData? icon;
  final List recordings;
  final List contributions;

  const MobileRecording({
    super.key,
    required this.fileName,
    required this.lesson,
    required this.material,
    this.icon,
    required this.recordings,
    required this.contributions,
  });

  @override
  State<MobileRecording> createState() => _MobileRecordingState();
}

class _MobileRecordingState extends State<MobileRecording> {
  String uploadType = 'recordings';

  final String url = AppUtils.$serverDir;

  @override
  Widget build(BuildContext context) {
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
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppUtils.mainBlue(context).withOpacity(0.5),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: AppUtils.mainBlue(context),
                ),
              ),
              Gap(10),
              SizedBox(
                  width: 250,
                  child: Text(widget.material['name'],
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 18))),
            ],
          )),
    );
  }
}
