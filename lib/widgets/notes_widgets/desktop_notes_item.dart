import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class DesktopNotesItem extends StatefulWidget {
  final Map lesson;
  final Function onPressed;

  const DesktopNotesItem(
      {super.key, required this.lesson, required this.onPressed});

  @override
  State<DesktopNotesItem> createState() => _DesktopNotesItemState();
}
 
class _DesktopNotesItemState extends State<DesktopNotesItem> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final path = lesson['path'].toString();
    final segments = path.split('/');
    final lastSegment = segments.last;

    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
        ),
        child: Row(children: [
          Text(lastSegment,
              style: TextStyle(
                  fontSize: 18,
                  color: AppUtils.$mainBlue,
                  fontWeight: FontWeight.bold)),
          Gap(10),
          Text(lesson['name'], style: TextStyle(fontSize: 16)),
          Spacer(),
          Consumer<TogglesProvider>(
              builder: (BuildContext context, toggleProvider, _) {
            return TextButton(
              onPressed: () {
                toggleProvider.toggleSelectLesson();
                widget.onPressed(lesson);
              },
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
              child: Text("View more . . ."),
            );
          })
        ]));
  }
}
