import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletUnitHolder extends StatelessWidget {
  const TabletUnitHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width / 2.5,
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
          Gap(5),
          Divider(
            color: AppUtils.$mainGrey,
          ),
          Gap(5),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FluentIcons.book_24_regular),
                  Gap(5),
                  Expanded(
                      child: Text("Notes",
                          style: TextStyle(
                              fontSize: 18, color: AppUtils.$mainBlue))),
                  Text("2")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FluentIcons.slide_content_24_regular),
                  Gap(5),
                  Expanded(
                      child: Text("Slides",
                          style: TextStyle(
                              fontSize: 18, color: AppUtils.$mainBlue))),
                  Text("4")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FluentIcons.video_24_regular),
                  Gap(5),
                  Expanded(
                      child: Text("Recordings",
                          style: TextStyle(
                              fontSize: 18, color: AppUtils.$mainBlue))),
                  Text("1")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FluentIcons.person_32_regular),
                  Gap(5),
                  Expanded(
                      child: Text("Student Contributions",
                          style: TextStyle(
                              fontSize: 18, color: AppUtils.$mainBlue))),
                  Text("1")
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
