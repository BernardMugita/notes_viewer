import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';

class RecentlyViewed extends StatefulWidget {
  const RecentlyViewed({super.key});

  @override
  State<RecentlyViewed> createState() => _RecentlyViewedState();
}

class _RecentlyViewedState extends State<RecentlyViewed> {
  @override
  Widget build(BuildContext context) {
    final uploadType = 'recordings';
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppUtils.mainGrey(context)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        spacing: 20,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: uploadType == 'notes'
                ? Colors.purpleAccent.withOpacity(0.2)
                : uploadType == 'slides'
                    ? Colors.amber.withOpacity(0.2)
                    : uploadType == 'recordings' || uploadType == 'recording'
                        ? AppUtils.mainBlue(context).withOpacity(0.2)
                        : uploadType == "student_contributions"
                            ? Colors.deepOrange.withOpacity(0.2)
                            : AppUtils.mainGreen(context).withOpacity(0.2),
            child: Icon(
              uploadType == 'notes'
                  ? FluentIcons.book_24_regular
                  : uploadType == 'slides'
                      ? FluentIcons.slide_content_24_regular
                      : uploadType == 'recordings' || uploadType == 'recording'
                          ? FluentIcons.video_24_regular
                          : uploadType == "student_contributions"
                              ? FluentIcons.people_20_regular
                              : FluentIcons.person_24_regular,
              color: uploadType == 'notes'
                  ? Colors.purpleAccent
                  : uploadType == 'slides'
                      ? Colors.amber
                      : uploadType == 'recordings' || uploadType == 'recording'
                          ? AppUtils.mainBlue(context)
                          : uploadType == "student_contributions"
                              ? Colors.deepOrange
                              : AppUtils.mainGreen(context),
              size: 100,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: VerticalDivider(
              color: AppUtils.mainGrey(context),
              thickness: 1,
              width: 10,
            ),
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "METABOLISM NOTES By Dr Owuor",
                style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  "lorem ipsum  lorem ipsum  lorem ipsum lorem ipsum lorem ipsum  lorem ipsum  lorem ipsum",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Gap(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Divider(
                  color: AppUtils.mainGrey(context),
                  thickness: 1,
                ),
              ),
              Text(
                "16 minutes 06 seconds left",
                style:
                    TextStyle(fontSize: 16, color: AppUtils.mainGrey(context)),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Icon(FluentIcons.comment_24_regular),
                        Text("0")
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(FluentIcons.thumb_like_24_regular),
                        Text("0")
                      ],
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Resume",
                          style: TextStyle(
                              color: AppUtils.mainBlue(context), fontSize: 16, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
