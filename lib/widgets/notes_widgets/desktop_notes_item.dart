import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopNotesItem extends StatelessWidget {
  const DesktopNotesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
        ),
        child: Row(children: [
          Text("UNITCODE001",
              style: TextStyle(
                  fontSize: 18,
                  color: AppUtils.$mainBlue,
                  fontWeight: FontWeight.bold)),
          Gap(10),
          Text("Introduction to Anatomy", style: TextStyle(fontSize: 16)),
          Spacer(),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
            child: Text("View more . . ."),
          )
        ]));
  }
}
