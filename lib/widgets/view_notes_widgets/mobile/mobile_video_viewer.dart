import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class MobileVideoViewer extends StatefulWidget {
  final String fileName;

  const MobileVideoViewer({
    super.key,
    required this.fileName,
  });

  @override
  State<MobileVideoViewer> createState() => _MobileVideoViewerState();
}

class _MobileVideoViewerState extends State<MobileVideoViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppUtils.$mainBlack, borderRadius: BorderRadius.circular(5)),
      height: MediaQuery.of(context).size.height / 1.25,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  widget.fileName,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: AppUtils.$mainWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.$mainWhite,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.$mainWhite,
                      )),
                ],
              )
            ],
          ),
          Gap(5),
          Divider(
            color: AppUtils.$mainGrey,
          ),
          Gap(5),
          Expanded(
              child: CircleAvatar(
            radius: 50,
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                FluentIcons.play_24_regular,
                size: 30,
              ),
            ),
          )),
          Gap(5),
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                child: LinearProgressIndicator(
                  value: 0.1,
                  backgroundColor: AppUtils.$mainGrey,
                  borderRadius: BorderRadius.circular(30),
                  color: AppUtils.$mainBlue,
                ),
              ),
              Gap(10),
              Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.play_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.fast_forward_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.rewind_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text("00:00/00:00",
                          style: TextStyle(color: AppUtils.$mainWhite)),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.settings_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                      Gap(5),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          FluentIcons.full_screen_maximize_24_regular,
                          color: AppUtils.$mainWhite,
                          size: 30,
                        ),
                      ),
                    ],
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
