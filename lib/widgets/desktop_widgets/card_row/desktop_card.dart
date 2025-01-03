import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopCard extends StatelessWidget {
  const DesktopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
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
              child: Icon(FluentIcons.book_24_regular, color: AppUtils.$mainWhite),
            ),
            Gap(10),
            Text("Notes Uploaded"),
            Text("Total: 10"),
          ],
        ),
      ),
    );
  }
}
