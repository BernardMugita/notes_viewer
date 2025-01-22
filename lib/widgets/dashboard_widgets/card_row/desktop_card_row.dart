import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/dashboard_widgets/card_row/desktop_card.dart';
import 'package:provider/provider.dart';

class DesktopCardRow extends StatefulWidget {
  final double users;
  final Map materialCount;
  const DesktopCardRow(
      {super.key, required this.users, required this.materialCount});

  @override
  State<DesktopCardRow> createState() => _DesktopCardRowState();
}

class _DesktopCardRowState extends State<DesktopCardRow> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(fontSize: 16, color: AppUtils.$mainGrey)),
          Gap(10),
          Row(
            children: [
              if (user.isNotEmpty && user['role'] == 'admin')
                DesktopCard(
                  users: widget.users,
                  material: "",
                  count: 0,
                ),
              for (var material in widget.materialCount.entries)
                DesktopCard(
                  users: 0,
                  material: material.key,
                  count: widget.materialCount[material.key],
                )
            ],
          ),
        ],
      ),
    );
  }
}
