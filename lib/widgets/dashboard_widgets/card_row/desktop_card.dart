import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopCard extends StatefulWidget {
  final double users;
  final String material;
  final double count;

  const DesktopCard(
      {super.key,
      required this.users,
      required this.material,
      required this.count});

  @override
  State<DesktopCard> createState() => _DesktopCardState();
}

class _DesktopCardState extends State<DesktopCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: widget.material != "student_contributions"
            ? const EdgeInsets.only(right: 20)
            : const EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: AppUtils.$mainWhite,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 224, 224, 224),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(10, 5),
              )
            ]),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: AppUtils.$mainBlue,
              radius: 30,
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
                  color: AppUtils.$mainWhite),
            ),
            Gap(10),
            Text(widget.users > 0
                ? "REGISTERED STUDENTS"
                : widget.material
                    .toString()
                    .toUpperCase()
                    .replaceAll('_', " ")),
            Text("Total: ${widget.users > 0 ? widget.users : widget.count}"),
          ],
        ),
      ),
    );
  }
}
