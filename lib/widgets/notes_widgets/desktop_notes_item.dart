import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/notes_widgets/desktop_notes_overview.dart';
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
  bool isRightClicked = false;
  bool actionMode = false;
  Map selectedLesson = {};
  bool isSelectedLesson = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final path = lesson['path'].toString();
    final segments = path.split('/');
    final lastSegment = segments.last;

    final user = context.read<UserProvider>().user;

    Future<void> onRightClick(PointerDownEvent event) async {
      if (event.kind == PointerDeviceKind.mouse &&
          (event.buttons & kSecondaryMouseButton) != 0) {
        setState(() {
          isRightClicked = !isRightClicked;
          actionMode = !actionMode;

          if (selectedLesson.isNotEmpty) {
            selectedLesson.clear();
          } else {
            selectedLesson['id'] = widget.lesson;
            isSelectedLesson =
                selectedLesson['id']['id'] == widget.lesson['id'];
          }
        });
      }
    }

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
        child: Listener(
          onPointerDown: onRightClick,
          child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
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
                    if (user.isNotEmpty &&
                        user['role'] == 'admin' &&
                        isSelectedLesson &&
                        actionMode)
                      SizedBox(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isRightClicked = false;
                                      // _showDialog(context,
                                      //     courses: courses, token: tokenRef);
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppUtils.mainGreen(context)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)))),
                                  child: Row(
                                    children: [
                                      Icon(FluentIcons.edit_24_regular,
                                          color: AppUtils.mainWhite(context)),
                                      const Gap(5),
                                      Text("Edit",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainWhite(context))),
                                    ],
                                  )),
                              Gap(5),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isRightClicked = false;
                                      _showDeleteDialog(context);
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppUtils.mainRed(context)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)))),
                                  child: Row(
                                    children: [
                                      Icon(FluentIcons.delete_24_regular,
                                          color: AppUtils.mainWhite(context)),
                                      const Gap(5),
                                      Text("Delete",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainWhite(context))),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    Gap(10),
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
                    DesktopNotesOverview(
                      lesson: lesson,
                    )
                ],
              )),
        ));
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
        context: content,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppUtils.mainWhite(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 300,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.delete_24_regular,
                      color: AppUtils.mainRed(context),
                      size: 80,
                    ),
                    Gap(20),
                    Text(
                      "Confirm Delete",
                      style: TextStyle(
                          fontSize: 18, color: AppUtils.mainRed(context)),
                    ),
                    Text(
                      "Are you sure you want to delete this lesson? Note that this action is irreversible.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainBlueAccent(context)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.dismiss_24_filled,
                                        color: AppUtils.mainRed(context)),
                                    const Gap(5),
                                    Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.mainRed(context))),
                                  ],
                                ))),
                        Gap(10),
                        Expanded(
                          child: Consumer<LessonsProvider>(
                              builder: (context, lessonsProvider, _) {
                            return ElevatedButton(
                                onPressed: lessonsProvider.isLoading
                                    ? null
                                    : () {
                                        lessonsProvider.deleteLesson(tokenRef,
                                            selectedLesson['id']['id']);
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.pop(context);
                                        });
                                      },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainRed(context)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: lessonsProvider.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FluentIcons.delete_24_regular,
                                              color:
                                                  AppUtils.mainWhite(context)),
                                          const Gap(5),
                                          Text("Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppUtils.mainWhite(
                                                      context))),
                                        ],
                                      ));
                          }),
                        )
                      ],
                    ))
                  ],
                )),
          );
        });
  }
}
