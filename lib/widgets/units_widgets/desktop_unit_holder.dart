import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopUnitHolder extends StatefulWidget {
  final Map unit;

  const DesktopUnitHolder({super.key, required this.unit});

  @override
  State<DesktopUnitHolder> createState() => _DesktopUnitHolderState();
}

class _DesktopUnitHolderState extends State<DesktopUnitHolder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;

    return MouseRegion(
      onEnter: (_) => setState(() {
        _isHovered = true;
      }),
      onExit: (_) => setState(() {
        _isHovered = false;
      }),
      child: GestureDetector(
        onTap: () {
          context.go('/units/notes');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width / 6,
          decoration: BoxDecoration(
            color: _isHovered ? AppUtils.$mainBlue : AppUtils.$mainWhite,
            borderRadius: BorderRadius.circular(5),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                FluentIcons.doctor_24_regular,
                color: _isHovered ? AppUtils.$mainWhite : AppUtils.$mainBlue,
                size: 45,
              ),
              Text(
                unit['name'],
                style: TextStyle(
                  fontSize: 24,
                  color: _isHovered ? AppUtils.$mainWhite : AppUtils.$mainBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(5),
              Divider(
                color: AppUtils.$mainGrey,
              ),
              const Gap(5),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.book_24_regular,
                        color: _isHovered
                            ? AppUtils.$mainWhite
                            : AppUtils.$mainBlue,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          "Notes",
                          style: TextStyle(
                              fontSize: 18,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue),
                        ),
                      ),
                      Text(
                        "2",
                        style: TextStyle(
                          color: _isHovered
                              ? AppUtils.$mainWhite
                              : AppUtils.$mainBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.slide_content_24_regular,
                        color: _isHovered
                            ? AppUtils.$mainWhite
                            : AppUtils.$mainBlue,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          "Slides",
                          style: TextStyle(
                              fontSize: 18,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue),
                        ),
                      ),
                      Text(
                        "4",
                        style: TextStyle(
                          color: _isHovered
                              ? AppUtils.$mainWhite
                              : AppUtils.$mainBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.video_24_regular,
                        color: _isHovered
                            ? AppUtils.$mainWhite
                            : AppUtils.$mainBlue,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          "Recordings",
                          style: TextStyle(
                              fontSize: 18,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue),
                        ),
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                          color: _isHovered
                              ? AppUtils.$mainWhite
                              : AppUtils.$mainBlue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.person_32_regular,
                        color: _isHovered
                            ? AppUtils.$mainWhite
                            : AppUtils.$mainBlue,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          "Student Contributions",
                          style: TextStyle(
                              fontSize: 18,
                              color: _isHovered
                                  ? AppUtils.$mainWhite
                                  : AppUtils.$mainBlue),
                        ),
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                          color: _isHovered
                              ? AppUtils.$mainWhite
                              : AppUtils.$mainBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
