import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:note_viewer/utils/app_utils.dart';

class MobileNotesOverview extends StatefulWidget {
  final Map lesson;

  const MobileNotesOverview({super.key, required this.lesson});

  @override
  State<MobileNotesOverview> createState() => _MobileNotesOverviewState();
}

class _MobileNotesOverviewState extends State<MobileNotesOverview> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppUtils.mainWhite(context),
          borderRadius: BorderRadius.circular(5),
        ),
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          children: [
            Column(
              spacing: 5,
              children: lesson['files'].entries.map<Widget>((entry) {
                final key = entry.key;
                final value = entry.value;

                return _buildLessonOverviewItems(context, key, value.length);
              }).toList(),
            ),
          ],
        ));
  }

  Widget _buildLessonOverviewItems(
      BuildContext context, String itemName, double itemCount) {
    return SizedBox(
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: itemName == 'notes'
                ? Colors.purpleAccent.withOpacity(0.2)
                : itemName == 'slides'
                    ? Colors.amber.withOpacity(0.2)
                    : itemName == 'recordings'
                        ? AppUtils.mainBlue(context).withOpacity(0.2)
                        : itemName == "student_contributions"
                            ? Colors.deepOrange.withOpacity(0.2)
                            : AppUtils.mainGreen(context).withOpacity(0.2),
            child: Icon(
              size: 18,
              itemName == 'notes'
                  ? FluentIcons.book_24_regular
                  : itemName == 'slides'
                      ? FluentIcons.slide_content_24_regular
                      : itemName == 'recordings'
                          ? FluentIcons.video_24_regular
                          : FluentIcons.person_32_regular,
              color: itemName == 'notes'
                  ? Colors.purpleAccent
                  : itemName == 'slides'
                      ? Colors.amber
                      : itemName == 'recordings'
                          ? AppUtils.mainBlue(context)
                          : itemName == "student_contributions"
                              ? Colors.deepOrange
                              : const Color(0xFF008800),
            ),
          ),
          Expanded(
            child: Text(
              itemName,
              style: TextStyle(fontSize: 18, color: AppUtils.mainBlue(context)),
            ),
          ),
          Text(itemCount.toString()),
        ],
      ),
    );
  }
}
