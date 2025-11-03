import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:gap/gap.dart';

class MobileRelevantVideos extends StatefulWidget {
  final Map material;

  const MobileRelevantVideos({super.key, required this.material});

  @override
  State<MobileRelevantVideos> createState() => _MobileRelevantVideosState();
}

class _MobileRelevantVideosState extends State<MobileRelevantVideos> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _isHovered
              ? AppUtils.mainBlue(context).withOpacity(0.05)
              : Colors.grey.shade50,
          border: Border.all(
            color: _isHovered
                ? AppUtils.mainBlue(context).withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Video Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppUtils.mainBlue(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FluentIcons.play_circle_24_filled,
                color: AppUtils.mainBlue(context),
                size: 20,
              ),
            ),
            const Gap(12),

            // Video Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.material['name'],
                    style: TextStyle(
                      fontSize: 14,
                      color: _isHovered
                          ? AppUtils.mainBlue(context)
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
                color: AppUtils.mainBlue(context),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
