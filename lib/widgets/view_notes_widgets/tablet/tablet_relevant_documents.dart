import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletRelevantDocuments extends StatelessWidget {
  const TabletRelevantDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: MediaQuery.of(context).size.height / 7,
              decoration: BoxDecoration(
                  color: AppUtils.$mainBlueAccent,
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
              child: Center(
                  child: Icon(
                FluentIcons.document_pdf_24_regular,
                color: AppUtils.$mainRed,
                size: 40,
              ))),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Philosophy of Anatomy",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppUtils.$mainBlue,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Gap(5),
              Row(
                children: [
                  Text(
                    "Duration",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppUtils.$mainBlack),
                  ),
                  Gap(5),
                  Text(
                    "45 seconds read",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              Gap(5),
              Row(
                children: [
                  Text(
                    "Date Published:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppUtils.$mainBlack),
                  ),
                  Gap(5),
                  Text(
                    "2022-01-01",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
