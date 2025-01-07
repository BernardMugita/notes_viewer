import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopDocumentViewer extends StatefulWidget {
  final String fileName;

  const DesktopDocumentViewer({super.key, required this.fileName});

  @override
  State<DesktopDocumentViewer> createState() => _DesktopDocumentViewerState();
}

class _DesktopDocumentViewerState extends State<DesktopDocumentViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppUtils.$mainWhite, borderRadius: BorderRadius.circular(5)),
      height: MediaQuery.of(context).size.height / 1.25,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.fileName,
                style: TextStyle(
                    color: AppUtils.$mainBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_like_24_regular,
                        color: AppUtils.$mainBlack,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FluentIcons.thumb_dislike_24_regular,
                        color: AppUtils.$mainBlack,
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
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppUtils.$mainBlueAccent,
              child: Row(
                children: [
                  Icon(FluentIcons.arrow_previous_24_filled),
                  Expanded(child: SizedBox()),
                  Icon(FluentIcons.arrow_next_24_regular),
                ],
              ),
            ),
          ),
          Gap(10),
          SizedBox(
            width: double.infinity,
            child: Text(
              textAlign: TextAlign.center,
              "Page 1/1",
              style: TextStyle(color: AppUtils.$mainBlue),
            ),
          )
        ],
      ),
    );
  }
}
