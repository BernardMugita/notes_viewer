import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_notes_overview.dart';
import 'package:provider/provider.dart';

class DesktopNotesItem extends StatefulWidget {
  final Map lesson;
  final Map selectedLesson;
  final Function onPressed;

  const DesktopNotesItem(
      {super.key,
      required this.lesson,
      required this.onPressed,
      required this.selectedLesson});

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
    final isSelectedLesson = lesson['id'] == widget.selectedLesson['id'];

    return GestureDetector(
        onTap: () {
          final routeName = '/units/notes/${lesson['name']}';
          context.go(routeName, extra: {
            'lesson_id': lesson['id'],
            'unit_id': lesson['unit_id'],
            'lesson_name': lesson['name'],
          });
          context.read<TogglesProvider>().deActivateSearchMode();
        },
        child: Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: AppUtils.mainWhite(context),
                border: Border.all(color: AppUtils.mainGrey(context)),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              spacing: 5,
              children: [
                Row(children: [
                  Text(lastSegment,
                      style: TextStyle(
                          fontSize: 18,
                          color: AppUtils.mainBlue(context),
                          fontWeight: FontWeight.bold)),
                  Gap(10),
                  Text(lesson['name'], style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Consumer<TogglesProvider>(
                      builder: (BuildContext context, toggleProvider, _) {
                    return IconButton(
                      onPressed: () {
                        toggleProvider.toggleSelectLesson();
                        if (widget.selectedLesson != lesson) {
                          widget.onPressed(lesson);
                        } else {
                          widget.onPressed({});
                        }
                      },
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      icon:
                          (toggleProvider.isLessonSelected && isSelectedLesson)
                              ? Icon(FluentIcons.chevron_up_24_filled)
                              : Icon(FluentIcons.chevron_down_24_filled),
                    );
                  })
                ]),
                if (context.watch<TogglesProvider>().isLessonSelected &&
                    isSelectedLesson)
                  Divider(
                    color: AppUtils.mainBlueAccent(context),
                  ),
                if (context.watch<TogglesProvider>().isLessonSelected &&
                    isSelectedLesson)
                  DesktopNotesOverview(
                    lesson: lesson,
                  )
              ],
            )));
  }
}
