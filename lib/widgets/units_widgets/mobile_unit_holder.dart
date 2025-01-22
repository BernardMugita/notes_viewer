import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class MobileUnitHolder extends StatefulWidget {
  final Map unit;

  const MobileUnitHolder({super.key, required this.unit});

  @override
  State<MobileUnitHolder> createState() => _MobileUnitHolderState();
}

class _MobileUnitHolderState extends State<MobileUnitHolder> {
  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;

    return GestureDetector(
      onTap: () {
        final unitId = unit['id'];
        context.read<UnitsProvider>().setUnitId(unitId);
        String? token = context.read<AuthProvider>().token;
        if (token != null) {
          context.read<UserProvider>().fetchUserDetails(token);
        }
        context.go('/units/notes');
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          color: AppUtils.$mainWhite,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Icon(
              FluentIcons.doctor_24_regular,
              size: 35,
            ),
            Text(unit['name'],
                style: TextStyle(
                    fontSize: 20,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold)),
            Gap(2.5),
            Divider(
              color: AppUtils.$mainGrey,
            ),
            Gap(2.5),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      FluentIcons.book_24_regular,
                      size: 14,
                    ),
                    Gap(5),
                    SizedBox(
                      width: 80,
                      child: Text("Notes",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppUtils.$mainBlue,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    Spacer(),
                    Text("2")
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      FluentIcons.slide_content_24_regular,
                      size: 14,
                    ),
                    Gap(5),
                    SizedBox(
                      width: 80,
                      child: Text("Slides",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppUtils.$mainBlue,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    Spacer(),
                    Text("4")
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      FluentIcons.video_24_regular,
                      size: 14,
                    ),
                    Gap(5),
                    SizedBox(
                      width: 80,
                      child: Text("Recordings",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppUtils.$mainBlue,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    Spacer(),
                    Text("1")
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      FluentIcons.person_32_regular,
                      size: 14,
                    ),
                    Gap(5),
                    SizedBox(
                      width: 80,
                      child: Text("Contributions",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppUtils.$mainBlue,
                              overflow: TextOverflow.ellipsis)),
                    ),
                    Spacer(),
                    Text("1")
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
