import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/notes_widgets/tablet_notes_overview.dart';

class TabletNotesItem extends StatefulWidget {
  final Map lesson;
  final Function onPressed;

  const TabletNotesItem(
      {super.key, required this.lesson, required this.onPressed});

  @override
  State<TabletNotesItem> createState() => _TabletNotesItemState();
}

class _TabletNotesItemState extends State<TabletNotesItem> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final path = lesson['path'].toString();
    final segments = path.split('/');
    final lastSegment = segments.last;

    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 50,
            child: Text(lastSegment,
                style: TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold)),
          ),
          Gap(10),
          Expanded(child: Text(lesson['name'], style: TextStyle(fontSize: 14))),
          // Spacer(),
          TextButton(
            onPressed: () {
              _showDialog(context);
              widget.onPressed(lesson);
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
              child: TabletNotesOverview(
                lesson: widget.lesson,
              ),
            ),
          );
        });
  }
}
