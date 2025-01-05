import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletCard extends StatelessWidget {
  const TabletCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      width: MediaQuery.of(context).size.width / 3.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppUtils.$mainBlue,
            radius: 25,
            child: Icon(FluentIcons.book_24_regular,
                color: AppUtils.$mainWhite, size: 18),
          ),
          Gap(10),
          Text(
            textAlign: TextAlign.center,
            "10",
            style: TextStyle(fontSize: 20, color: AppUtils.$mainBlue),
          ),
          Text(
            textAlign: TextAlign.center,
            "Notes Uploaded",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
