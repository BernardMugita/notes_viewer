import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class MobileUnitHolder extends StatelessWidget {
  const MobileUnitHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
            size: 35,
          ),
          Text("Anatomy",
              style: TextStyle(
                  fontSize: 20,
                  color: AppUtils.$mainBlue,
                  fontWeight: FontWeight.bold)),
          Gap(2.5),
          Divider(
            color: AppUtils.$mainGrey,
          ),
          Gap(2.5),
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    FluentIcons.book_24_regular,
                    size: 14,
                  ),
                  Gap(5),
                  SizedBox(
                    width: 80,
                    child: Text("Notes",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppUtils.$mainBlue,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Spacer(),
                  Text("2")
                ],
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.slide_content_24_regular,
                    size: 14,
                  ),
                  Gap(5),
                  SizedBox(
                    width: 80,
                    child: Text("Slides",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppUtils.$mainBlue,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Spacer(),
                  Text("4")
                ],
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.video_24_regular,
                    size: 14,
                  ),
                  Gap(5),
                  SizedBox(
                    width: 80,
                    child: Text("Recordings",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppUtils.$mainBlue,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Spacer(),
                  Text("1")
                ],
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.person_32_regular,
                    size: 14,
                  ),
                  Gap(5),
                  SizedBox(
                    width: 80,
                    child: Text("Contributions",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppUtils.$mainBlue,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Spacer(),
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
