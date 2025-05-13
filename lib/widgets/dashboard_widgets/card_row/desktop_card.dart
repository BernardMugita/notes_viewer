import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

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
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.users > 0
                          ? "REGISTERED STUDENTS"
                          : widget.material
                              .toString()
                              .toUpperCase()
                              .replaceAll('_', " "),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          color: AppUtils.mainBlack(context),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total: ${widget.users > 0 ? widget.users : widget.count}",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppUtils.mainBlack(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: widget.material == 'notes'
                  ? Colors.purpleAccent.withOpacity(0.2)
                  : widget.material == 'slides'
                      ? Colors.amber.withOpacity(0.2)
                      : widget.material == 'recordings'
                          ? AppUtils.mainBlue(context).withOpacity(0.2)
                          : widget.material == "student_contributions"
                              ? Colors.deepOrange.withOpacity(0.2)
                              : AppUtils.mainGreen(context).withOpacity(0.2),
              radius: 20,
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
                color: widget.material == 'notes'
                    ? Colors.purpleAccent
                    : widget.material == 'slides'
                        ? Colors.amber
                        : widget.material == 'recordings'
                            ? AppUtils.mainBlue(context)
                            : widget.material == "student_contributions"
                                ? Colors.deepOrange
                                : const Color(0xFF008800),
              ),
            ),
          ],
        ),
        Gap(10),
        Positioned(
            top: 5,
            bottom: 5,
            left: 0,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                  color: widget.material == 'notes'
                      ? Colors.purpleAccent
                      : widget.material == 'slides'
                          ? Colors.amber
                          : widget.material == 'recordings'
                              ? AppUtils.mainBlue(context)
                              : widget.material == "student_contributions"
                                  ? Colors.deepOrange
                                  : AppUtils.mainGreen(context),
                  borderRadius: BorderRadius.circular(10)),
            ))
      ],
    );
  }
}
