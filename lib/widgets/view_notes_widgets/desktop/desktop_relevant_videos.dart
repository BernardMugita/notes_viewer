import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

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
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppUtils.mainWhite(context),
          border: Border.all(color: AppUtils.mainGrey(context))),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor: AppUtils.backgroundPanel(context),
            child: Icon(FluentIcons.video_24_regular,
                color: AppUtils.mainBlack(context)),
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.material['name'],
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: AppUtils.mainBlue(context),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  AppUtils.formatDate(widget.material['created_at']),
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
