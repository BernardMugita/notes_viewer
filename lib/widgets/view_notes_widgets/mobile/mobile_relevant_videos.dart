import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

class MobileRelevantVideos extends StatefulWidget {
  final Map material;

  const MobileRelevantVideos({super.key, required this.material});

  @override
  State<MobileRelevantVideos> createState() => _MobileRelevantVideosState();
}

class _MobileRelevantVideosState extends State<MobileRelevantVideos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppUtils.mainGrey(context))),
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(FluentIcons.video_24_regular),
          ),
          Gap(10),
          SizedBox(
            width: 150,
            child: Text(
              widget.material['name'],
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  color: AppUtils.mainBlue(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          Text(
            "45 minutes",
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
