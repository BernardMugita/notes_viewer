import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopRelevantVideos extends StatefulWidget {
  final Map material;

  const DesktopRelevantVideos({super.key, required this.material});

  @override
  State<DesktopRelevantVideos> createState() => _DesktopRelevantVideosState();
}

class _DesktopRelevantVideosState extends State<DesktopRelevantVideos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.height / 5,
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                color: AppUtils.$mainBlueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Icon(
                FluentIcons.play_24_filled,
                size: 40,
              ))),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.material['name'],
                    style: TextStyle(
                        fontSize: 18,
                        color: AppUtils.$mainBlue,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(5),
              Row(
                children: [
                  Text(
                    "Duration",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppUtils.$mainBlack),
                  ),
                  Gap(5),
                  Text(
                    "45 minutes",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              Gap(5),
              Row(
                children: [
                  Text(
                    "Date Published:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppUtils.$mainBlack),
                  ),
                  Gap(5),
                  Text(
                    AppUtils.formatDate(widget.material['created_at']),
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
