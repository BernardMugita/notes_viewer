import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/notes_widgets/mobile_notes_overview.dart';
import 'package:provider/provider.dart';

class MobileNotesItem extends StatefulWidget {
  final Map lesson;
  final Function onPressed;
  final Map selectedLesson;

  const MobileNotesItem(
      {super.key,
      required this.lesson,
      required this.onPressed,
      required this.selectedLesson});

  @override
  State<MobileNotesItem> createState() => _MobileNotesItemState();
}

class _MobileNotesItemState extends State<MobileNotesItem> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
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
          padding: const EdgeInsets.only(left: 10, top: 2.5, bottom: 2.5),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppUtils.mainGrey(context),
              )),
          child: Column(
            children: [
              Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.book_24_regular,
                        size: 32, color: AppUtils.mainGrey(context)),
                    SizedBox(
                        child: Text(AppUtils.toSentenceCase(lesson['name']),
                            style: TextStyle(
                                color: AppUtils.mainBlue(context),
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
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
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)))),
                        icon: (toggleProvider.isLessonSelected &&
                                isSelectedLesson)
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
                MobileNotesOverview(
                  lesson: widget.lesson,
                ),
            ],
          )),
    );
  }
}
