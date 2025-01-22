import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletCard extends StatefulWidget {
  final double users;
  final String material;
  final double count;

  const TabletCard(
      {super.key,
      required this.users,
      required this.material,
      required this.count});

  @override
  State<TabletCard> createState() => _TabletCardState();
}

class _TabletCardState extends State<TabletCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.$mainWhite,
        borderRadius: BorderRadius.circular(5),
      ),
      width: MediaQuery.of(context).size.width / 3.4,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppUtils.$mainBlue,
            radius: 25,
            child: Icon(
              widget.material == 'notes'
                  ? FluentIcons.book_24_regular
                  : widget.material == 'slides'
                      ? FluentIcons.slide_content_24_regular
                      : widget.material == 'recordings'
                          ? FluentIcons.video_24_regular
                          : widget.material == "student_contributions"
                              ? FluentIcons.people_20_regular
                              : FluentIcons.person_24_regular,
              color: AppUtils.$mainWhite,
            ),
          ),
          Gap(10),
          Text(
            widget.users > 0
                ? "REGISTERED STUDENTS"
                : widget.material.toString().toUpperCase().replaceAll('_', " "),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            textAlign: TextAlign.center,
            "Total: ${widget.users > 0 ? widget.users : widget.count}",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
