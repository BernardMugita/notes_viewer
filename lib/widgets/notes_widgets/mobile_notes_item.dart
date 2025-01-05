import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/notes_widgets/mobile_notes_overview.dart';

class MobileNotesItem extends StatelessWidget {
  const MobileNotesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 50,
            child: Text("UNITCODE001",
                style: TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold)),
          ),
          Gap(10),
          Expanded(
              child: Text("Introduction to Anatomy",
                  style: TextStyle(fontSize: 14))),
          // Spacer(),
          TextButton(
            onPressed: () {
              _showDialog(context);
            },
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
            child: Text("View more"),
          )
        ]));
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              width: MediaQuery.of(context).size.height * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: MobileNotesOverview(),
            ),
          );
        });
  }
}
