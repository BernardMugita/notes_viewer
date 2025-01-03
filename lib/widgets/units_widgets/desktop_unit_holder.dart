import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopUnitHolder extends StatelessWidget {
  const DesktopUnitHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width / 6,
      decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
          borderRadius: BorderRadius.circular(5),
          // boxShadow: [
          //   BoxShadow(
          //     color: const Color.fromARGB(255, 224, 224, 224),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: Offset(10, 5),
          //   )
          // ]
          ),
      child: Column(
        children: [
          Icon(
            FluentIcons.doctor_24_regular,
            size: 45,
          ),
          Text("Anatomy",
              style: TextStyle(
                  fontSize: 24,
                  color: AppUtils.$mainBlue,
                  fontWeight: FontWeight.bold)),
          Column(
            children: [
              Row(
                children: [
                  Icon(FluentIcons.book_24_regular),
                  Gap(5),
                  Text("Notes",
                      style:
                          TextStyle(fontSize: 18, color: AppUtils.$mainBlue)),
                  Spacer(),
                  Text("2")
                ],
              ),
              Row(
                children: [
                  Icon(FluentIcons.slide_content_24_regular),
                  Gap(5),
                  Text("Slides",
                      style:
                          TextStyle(fontSize: 18, color: AppUtils.$mainBlue)),
                  Spacer(),
                  Text("4")
                ],
              ),
              Row(
                children: [
                  Icon(FluentIcons.video_24_regular),
                  Gap(5),
                  Text("Recordings",
                      style:
                          TextStyle(fontSize: 18, color: AppUtils.$mainBlue)),
                  Spacer(),
                  Text("1")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
