import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/notes_widgets/tablet_notes_overview.dart';

class TabletNotesItem extends StatelessWidget {
  const TabletNotesItem({super.key});

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
          Text("Introduction to Anatomy", style: TextStyle(fontSize: 14)),
          Spacer(),
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
              width: MediaQuery.of(context).size.height * 0.75,
              height: MediaQuery.of(context).size.height * 0.35,
              child: TabletNotesOverview(),
            ),
          );
        });
  }
}
