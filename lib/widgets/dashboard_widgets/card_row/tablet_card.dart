import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

class TabletCard extends StatefulWidget {
  final int users;
  final String material;
  final int count;

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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Gap(10),
              SizedBox(
                  width: 100,
                  child: Text(
                    widget.users > 0
                        ? "REGISTERED STUDENTS"
                        : widget.material == "student_contributions"
                            ? widget.material
                                .toString()
                                .toUpperCase()
                                .replaceAll('_', " ")
                                .split(' ')[1]
                            : widget.material
                                .toString()
                                .toUpperCase()
                                .replaceAll('_', " "),
                    textAlign: TextAlign.center,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  )),
              Text(
                textAlign: TextAlign.center,
                "Total: ${widget.users > 0 ? widget.users : widget.count}",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 5,
            right: 5,
            child: Container(
              height: 2.5,
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
