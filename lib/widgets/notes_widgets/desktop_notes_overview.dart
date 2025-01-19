import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopNotesOverview extends StatefulWidget {
  final Map lesson;

  const DesktopNotesOverview({super.key, required this.lesson});

  @override
  State<DesktopNotesOverview> createState() => _DesktopNotesOverviewState();
}

class _DesktopNotesOverviewState extends State<DesktopNotesOverview> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2.8,
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
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  lesson['name'],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppUtils.$mainBlue),
                ),
              ),
              Gap(20),
              Column(
                children: lesson['files'].entries.map<Widget>((entry) {
                  final key = entry.key;
                  final value = entry.value;

                  return _buildLessonOverviewItems(context, key, value.length);
                }).toList(),
              ),
              Gap(20),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(const EdgeInsets.all(20)),
                  backgroundColor: WidgetStatePropertyAll(AppUtils.$mainBlue),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  final routeName = '/units/notes/${lesson['name']}';
                  context.go(routeName, extra: {
                    'lesson_id': lesson['id'],
                    'unit_id': lesson['unit_id']
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Read Notes",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppUtils.$mainWhite,
                      ),
                    ),
                    const Gap(5),
                    Icon(
                      FluentIcons.book_add_24_regular,
                      size: 16,
                      color: AppUtils.$mainWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLessonOverviewItems(
      BuildContext context, String itemName, double itemCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            itemName == 'notes'
                ? FluentIcons.book_24_regular
                : itemName == 'slides'
                    ? FluentIcons.slide_content_24_regular
                    : itemName == 'recordings'
                        ? FluentIcons.video_24_regular
                        : FluentIcons.person_32_regular,
            color: AppUtils.$mainBlue,
          ),
          const Gap(5),
          Expanded(
            child: Text(
              itemName,
              style: TextStyle(fontSize: 18, color: AppUtils.$mainBlue),
            ),
          ),
          Text(itemCount.toString()),
        ],
      ),
    );
  }
}
