import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';

class DiscussionForum extends StatefulWidget {
  const DiscussionForum({super.key});

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppUtils.backgroundPanel(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [Forummessage()],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Type your message"),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: AppUtils.mainBlue(context),
                child: Icon(FluentIcons.send_24_regular,
                    color: AppUtils.mainWhite(context)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Forummessage extends StatelessWidget {
  const Forummessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(
                  backgroundColor: AppUtils.backgroundPanel(context),
                  child: Icon(
                    FluentIcons.person_24_regular,
                    color: AppUtils.mainBlack(context),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("username"),
                  Text("10:00 am",
                      style: TextStyle(
                          fontSize: 12, color: AppUtils.mainGrey(context))),
                ],
              )
            ],
          ),
          Divider(
            color: AppUtils.mainGrey(context),
          ),
          Column(
            children: [
              Text(
                  "This is a discussion message, This is a discussion message, This is a discussion message",
                  style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
