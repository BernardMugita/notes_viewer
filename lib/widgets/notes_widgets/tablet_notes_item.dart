import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/notes_widgets/tablet_notes_overview.dart';
import 'package:provider/provider.dart';

class TabletNotesItem extends StatefulWidget {
  final Map lesson;
  final Map selectedLesson;
  final Function onPressed;

  const TabletNotesItem({
    super.key,
    required this.lesson,
    required this.onPressed,
    required this.selectedLesson,
  });

  @override
  State<TabletNotesItem> createState() => _TabletNotesItemState();
}

class _TabletNotesItemState extends State<TabletNotesItem> {
  bool _isHovered = false;
  Map selectedLesson = {};
  bool isSelectedLesson = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final path = lesson['path'].toString();
    final segments = path.split('/');
    final lastSegment = segments.isNotEmpty ? segments.last : '';

    final user = context.read<UserProvider>().user;
    isSelectedLesson = widget.selectedLesson['id'] == lesson['id'];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          final routeName = '/units/notes/${lesson['name']}';
          context.go(routeName, extra: {
            'lesson_id': lesson['id'],
            'unit_id': lesson['unit_id'],
            'lesson_name': lesson['name'],
          });
          context.read<TogglesProvider>().deActivateSearchMode();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                _isHovered ? AppUtils.mainBlue(context) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? AppUtils.mainBlue(context)
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Lesson Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? Colors.white.withOpacity(0.2)
                          : AppUtils.mainBlue(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FluentIcons.book_open_24_filled,
                      size: 20,
                      color: _isHovered
                          ? Colors.white
                          : AppUtils.mainBlue(context),
                    ),
                  ),
                  const Gap(12),

                  // Lesson Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (lastSegment.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? Colors.white.withOpacity(0.2)
                                      : AppUtils.mainBlue(context)
                                          .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  lastSegment,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _isHovered
                                        ? Colors.white
                                        : AppUtils.mainBlue(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const Gap(6),
                        Text(
                          lesson['name'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isHovered
                                ? Colors.white
                                : AppUtils.mainBlack(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  Consumer<TogglesProvider>(
                    builder: (context, toggleProvider, _) {
                      return Row(
                        children: [
                          if (user.isNotEmpty && user['role'] == 'admin')
                            Container(
                              decoration: BoxDecoration(
                                color: _isHovered
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: PopupMenuButton<String>(
                                icon: Icon(
                                  FluentIcons.more_vertical_24_regular,
                                  color: _isHovered
                                      ? Colors.white
                                      : AppUtils.mainGrey(context),
                                ),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteDialog(context);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(FluentIcons.delete_24_regular,
                                            size: 18,
                                            color: AppUtils.mainRed(context)),
                                        const Gap(12),
                                        const Text('Delete Lesson'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Gap(8),
                          IconButton(
                            onPressed: () {
                              toggleProvider.toggleSelectLesson();
                              if (widget.selectedLesson != lesson) {
                                widget.onPressed(lesson);
                              } else {
                                widget.onPressed({});
                              }
                            },
                            icon: Icon(
                              (toggleProvider.isLessonSelected &&
                                      isSelectedLesson)
                                  ? FluentIcons.chevron_up_24_regular
                                  : FluentIcons.chevron_down_24_regular,
                              color: _isHovered
                                  ? Colors.white
                                  : AppUtils.mainGrey(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              // Expanded Details
              if (context.watch<TogglesProvider>().isLessonSelected &&
                  isSelectedLesson)
                Column(
                  children: [
                    const Gap(16),
                    Divider(
                      color: _isHovered
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey.shade300,
                      height: 1,
                    ),
                    const Gap(16),
                    TabletNotesOverview(lesson: lesson),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
      context: content,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            padding: const EdgeInsets.all(28),
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtils.mainRed(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.delete_24_regular,
                    color: AppUtils.mainRed(context),
                    size: 48,
                  ),
                ),
                const Gap(20),
                Text(
                  "Delete Lesson",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this lesson? This action cannot be undone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppUtils.mainGrey(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: AppUtils.mainGrey(context)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppUtils.mainBlack(context),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Consumer<LessonsProvider>(
                        builder: (context, lessonsProvider, _) {
                          return ElevatedButton(
                            onPressed: lessonsProvider.isLoading
                                ? null
                                : () {
                                    lessonsProvider.deleteLesson(
                                        tokenRef, widget.lesson['id']);
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      Navigator.pop(context);
                                    });
                                  },
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppUtils.mainRed(context),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: lessonsProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
