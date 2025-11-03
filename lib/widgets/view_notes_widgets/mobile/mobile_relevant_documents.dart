import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/utils/app_utils.dart';

class MobileRelevantDocuments extends StatefulWidget {
  final Map material;

  const MobileRelevantDocuments({super.key, required this.material});

  @override
  State<MobileRelevantDocuments> createState() =>
      _MobileRelevantDocumentsState();
}

class _MobileRelevantDocumentsState extends State<MobileRelevantDocuments> {
  bool _isHovered = false;

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return FluentIcons.document_pdf_24_filled;
      case 'docx':
      case 'doc':
        return FluentIcons.document_24_filled;
      case 'xlsx':
      case 'xls':
        return FluentIcons.document_table_24_filled;
      case 'ppt':
      case 'pptx':
        return FluentIcons.slide_layout_24_filled;
      default:
        return FluentIcons.document_24_filled;
    }
  }

  Color _getFileColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'docx':
      case 'doc':
        return Colors.blue;
      case 'xlsx':
      case 'xls':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.material['file']?.split('/').last ??
        widget.material['name'] ??
        'document.pdf';
    final fileColor = _getFileColor(fileName);
    final fileIcon = _getFileIcon(fileName);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _isHovered ? fileColor.withOpacity(0.05) : Colors.grey.shade50,
          border: Border.all(
            color: _isHovered
                ? fileColor.withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Document Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: fileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                fileIcon,
                color: fileColor,
                size: 20,
              ),
            ),
            const Gap(12),

            // Document Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.material['name'],
                    style: TextStyle(
                      fontSize: 14,
                      color: _isHovered
                          ? fileColor
                          : AppUtils.mainBlack(context),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.calendar_24_regular,
                        size: 12,
                        color: AppUtils.mainGrey(context),
                      ),
                      const Gap(4),
                      Text(
                        AppUtils.formatDate(widget.material['created_at']),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppUtils.mainGrey(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            if (_isHovered)
              Icon(
                FluentIcons.chevron_right_24_regular,
                color: fileColor,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
