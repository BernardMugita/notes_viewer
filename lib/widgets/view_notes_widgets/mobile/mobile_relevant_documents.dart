import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class MobileRelevantDocuments extends StatefulWidget {
  final Map material;

  const MobileRelevantDocuments({super.key, required this.material});

  @override
  State<MobileRelevantDocuments> createState() =>
      _MobileRelevantDocumentsState();
}

class _MobileRelevantDocumentsState extends State<MobileRelevantDocuments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppUtils.$mainGrey)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppUtils.$mainRed.withOpacity(0.3),
            child: Icon(
              FluentIcons.document_pdf_24_regular,
              color: AppUtils.$mainRed,
            ),
          ),
          Gap(10),
          Expanded(
            child: Text(
              widget.material['name'],
              style: TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  color: AppUtils.$mainBlue,
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
