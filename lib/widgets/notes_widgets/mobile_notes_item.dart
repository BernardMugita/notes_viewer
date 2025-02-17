import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/notes_widgets/mobile_notes_overview.dart';

class MobileNotesItem extends StatefulWidget {
  final Map lesson;
  final Function onPressed;

  const MobileNotesItem(
      {super.key, required this.lesson, required this.onPressed});

  @override
  State<MobileNotesItem> createState() => _MobileNotesItemState();
}

class _MobileNotesItemState extends State<MobileNotesItem> {
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
            width: 60,
            child: Text(lastSegment,
                style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold)),
          ),
          Gap(10),
          Expanded(
              child: Text(lesson['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
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
              width: MediaQuery.of(context).size.height * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: MobileNotesOverview(
                lesson: widget.lesson,
              ),
            ),
          );
        });
  }
}
