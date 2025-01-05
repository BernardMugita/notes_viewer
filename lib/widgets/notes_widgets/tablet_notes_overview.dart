import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletNotesOverview extends StatelessWidget {
  const TabletNotesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Introduction to Anatomy",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppUtils.$mainBlue),
                ),
              ),
              Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.book_24_regular,
                    color: AppUtils.$mainBlue,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      "Notes",
                      style: TextStyle(fontSize: 18, color: AppUtils.$mainBlue),
                    ),
                  ),
                  const Text("2"),
                ],
              ),
              Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.slide_content_24_regular,
                    color: AppUtils.$mainBlue,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      "Slides",
                      style: TextStyle(fontSize: 18, color: AppUtils.$mainBlue),
                    ),
                  ),
                  const Text("4"),
                ],
              ),
              Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.video_24_regular,
                    color: AppUtils.$mainBlue,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      "Recordings",
                      style: TextStyle(fontSize: 18, color: AppUtils.$mainBlue),
                    ),
                  ),
                  const Text("1"),
                ],
              ),
              Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.person_32_regular,
                    color: AppUtils.$mainBlue,
                  ),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      "Student Contributions",
                      style: TextStyle(fontSize: 18, color: AppUtils.$mainBlue),
                    ),
                  ),
                  const Text("1"),
                ],
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
                onPressed: () {},
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
}
