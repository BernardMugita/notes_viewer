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
          margin: widget.material != "student_contributions"
              ? const EdgeInsets.only(right: 20)
              : const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: AppUtils.mainShaddow(context),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(10, 5),
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Gap(10),
                    CircleAvatar(
                      backgroundColor: widget.material == 'notes'
                          ? Colors.purpleAccent.withOpacity(0.2)
                          : widget.material == 'slides'
                              ? Colors.amber.withOpacity(0.2)
                              : widget.material == 'recordings'
                                  ? AppUtils.mainBlue(context).withOpacity(0.2)
                                  : widget.material == "student_contributions"
                                      ? Colors.deepOrange.withOpacity(0.2)
                                      : AppUtils.mainGreen(context)
                                          .withOpacity(0.2),
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
              ),
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
          ),
        ));
  }
}
