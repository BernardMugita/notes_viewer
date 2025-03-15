import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

class TabletRelevantDocuments extends StatefulWidget {
  final Map material;

  const TabletRelevantDocuments({super.key, required this.material});

  @override
  State<TabletRelevantDocuments> createState() =>
      _TabletRelevantDocumentsState();
}

class _TabletRelevantDocumentsState extends State<TabletRelevantDocuments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppUtils.mainGrey(context))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppUtils.mainRed(context).withOpacity(0.3),
            child: Icon(
              FluentIcons.document_pdf_24_regular,
              color: AppUtils.mainRed(context),
            ),
          ),
          Gap(10),
          Expanded(
            child: Text(
              widget.material['name'],
              style: TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: AppUtils.mainBlue(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          Text(
            AppUtils.formatDate(widget.material['created_at']),
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
